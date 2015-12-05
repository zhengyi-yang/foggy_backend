"""
Read graphs in Open Street Maps osm format
Based on osm.py from brianw's osmgeocode
http://github.com/brianw/osmgeocode, which is based on osm.py from
comes from Graphserver:
http://github.com/bmander/graphserver/tree/master and is copyright (c)
2007, Brandon Martin-Anderson under the BSD License
Also contains a bunch of code from stackoverflow.
Consider using downloaded local data instead of downloading it from a server - may reduce running times by a lot!!!!
"""



# import cProfile
import datainterp
import xml.sax
import copy
from scipy.interpolate import interp1d
# from matplotlib import pyplot as plt
from math import radians, sin, cos, sqrt, asin
import numpy as np
import networkx

def haversine(lat1, lon1, lat2, lon2):

  R = 6372.8 # Earth radius in kilometers

  dLat = radians(lat2 - lat1)
  dLon = radians(lon2 - lon1)
  lat1 = radians(lat1)
  lat2 = radians(lat2)

  a = sin(dLat/2)**2 + cos(lat1)*cos(lat2)*sin(dLon/2)**2
  c = 2*asin(sqrt(a))

  return R * c

def avg_pollution_cost(nodes,osm,factor): #takes in a list of nodes, returns the total pollution cost of the way divided by the number of nodes.
    return total_pollution_cost(nodes,osm,factor) / len(nodes)

def load_func(xs,ys):
    result=[]
    for i in xs:
        result.append(i)
    return result

def getlengthofway(xs,ys): #seriously need to write this at some point.
    length=0
    for i in range(len(xs)-1):
        #print "lat1=",xs[i]
        length+=haversine(xs[i],ys[i],xs[i+1],ys[i+1])
    return length

def total_pollution_cost(nodes,osm,factor): #takes in a list of nodes, returns the total pollution cost of the way
    x,y= [osm[node].lat for node in nodes],[osm[node].lon for node in nodes]

    #print x,y
#    f = interp1d(x, y)
#    f2 = interp1d(x, y, kind='cubic')
    length = int(getlengthofway(x,y)*factor) #with this calculation, each evenly-spaced point is around 50 meters from each other
    M = max(1,length) #The reason this was slow is because every way is interpolated the same number of points regardless of length, what we want to do is to make the number of interpolating points directly proportional to the length of way.
    #in order to optimise this (to make number of interpolating points proportional to the length of way) we need to calculate the length of way.
    t = np.linspace(0, len(x), M) #creates M points from 0-len(x)
    x = np.interp(t, np.arange(len(x)), x)
    y = np.interp(t, np.arange(len(y)), y)
    tol = 0.0004 #problem with this weighting algorithm is that single-node streets can be disproportionately weighted compared to streets with many nodes...
    i, idx = 0, [0]
    j=0
    while i < len(x):
        total_dist = 0
        for j in range(i+1, len(x)):
            total_dist += sqrt((x[j]-x[j-1])**2 + (y[j]-y[j-1])**2)
            if total_dist > tol:
                idx.append(j)
                break
        i = j+1
    xn = x[idx]
    yn = y[idx]
    pollution_levels = load_func(xn,yn)
    result=0
    for i in pollution_levels: #this assumes all evenly points across all ways are actually equally spaced
        result+=i
    return result
'''
    print xn,yn
    fig, ax = plt.subplots()
    ax.plot(x, y, '-')
    ax.scatter(xn, yn, s=50)
    ax.set_aspect('equal')
    plt.show()
    return 5;
'''



def download_osm(left,bottom,right,top):
    """ Return a filehandle to the downloaded data."""
    from urllib import urlopen
    fp = urlopen( "http://api.openstreetmap.org/api/0.6/map?bbox=%f,%f,%f,%f"%(left,bottom,right,top) )
    return fp

def read_osm(filename_or_stream, factor, only_roads=True):
    """Read graph in OSM format from file specified by name or by stream object.
    Parameters
    ----------
    filename_or_stream : filename or stream object
    Returns
    -------
    G : Graph
    Examples
    --------
    """
    osm = OSM(filename_or_stream)
    G = networkx.Graph()

    for w in osm.ways.itervalues():
        if only_roads and 'highway' not in w.tags: #only_roads
            continue
        #print w
        G.add_path(w.nds, id=w.id, data=w, weight=avg_pollution_cost(w.nds,osm.nodes,factor))
    for n_id in G.nodes_iter():
        n = osm.nodes[n_id]
        G.node[n_id] = dict(data=n)
    return G


class Node:
    def __init__(self, id, lon, lat):
        self.id = id
        self.lon = lon
        self.lat = lat
        self.tags = {}

class Way:
    def __init__(self, id, osm):
        self.osm = osm
        self.id = id
        self.nds = []
        self.tags = {}

    def split(self, dividers):
        # slice the node-array using this nifty recursive function
        def slice_array(ar, dividers):
            for i in range(1,len(ar)-1):
                if dividers[ar[i]]>1:
                    #print "slice at %s"%ar[i]
                    left = ar[:i+1]
                    right = ar[i:]

                    rightsliced = slice_array(right, dividers)

                    return [left]+rightsliced
            return [ar]

        slices = slice_array(self.nds, dividers)

        # create a way object for each node-array slice
        ret = []
        i=0
        for slice in slices:
            littleway = copy.copy( self )
            littleway.id += "-%d"%i
            littleway.nds = slice
            ret.append( littleway )
            i += 1

        return ret



class OSM:
    def __init__(self, filename_or_stream):
        """ File can be either a filename or stream/file object."""
        nodes = {}
        ways = {}

        superself = self

        class OSMHandler(xml.sax.ContentHandler):
            @classmethod
            def setDocumentLocator(self,loc):
                pass

            @classmethod
            def startDocument(self):
                pass

            @classmethod
            def endDocument(self):
                pass

            @classmethod
            def startElement(self, name, attrs):
                if name=='node':
                    self.currElem = Node(attrs['id'], float(attrs['lon']), float(attrs['lat']))
                elif name=='way':
                    self.currElem = Way(attrs['id'], superself)
                elif name=='tag':
                    self.currElem.tags[attrs['k']] = attrs['v']
                elif name=='nd':
                    self.currElem.nds.append( attrs['ref'] )

            @classmethod
            def endElement(self,name):
                if name=='node':
                    nodes[self.currElem.id] = self.currElem
                elif name=='way':
                    ways[self.currElem.id] = self.currElem

            @classmethod
            def characters(self, chars):
                pass

        xml.sax.parse(filename_or_stream, OSMHandler)

        self.nodes = nodes
        self.ways = ways

        #count times each node is used
        node_histogram = dict.fromkeys( self.nodes.keys(), 0 )
        for way in self.ways.values():
            if len(way.nds) < 2:       #if a way has only one node, delete it out of the osm collection
                del self.ways[way.id]
            else:
                for node in way.nds:
                    node_histogram[node] += 1

        #use that histogram to split all ways, replacing the member set of ways
        new_ways = {}
        for id, way in self.ways.iteritems():
            split_ways = way.split(node_histogram)
            for split_way in split_ways:
                new_ways[split_way.id] = split_way
        self.ways = new_ways


def distance(lat1,lat2,lon1,lon2):
    #print lat1,lat2,lon1,lon2
    return haversine(lat1,lon1,lat2,lon2)

def getnode(G,lat,lon):
    closest = None
    shortest = 999999999999
    for n in G:
        if distance(G.node[n]['data'].lat,lat, G.node[n]['data'].lon, lon) < shortest:
            closest = n
            shortest = distance(G.node[n]['data'].lat,lat, G.node[n]['data'].lon, lon)
    return closest, shortest



def routepath(lat1,lon1,lat2,lon2,tolerance=0.02,factor=1000):
    G=read_osm(download_osm(round(min(lon1,lon2)-tolerance,2),round(min(lat1,lat2)-tolerance,2),round(max(lon1,lon2)+tolerance,2),round(max(lat1,lat2)+tolerance,2)),factor)
    startnode = getnode(G,lat1,lon1)[0]
    # print "startnode:",startnode
    endnode = getnode(G,lat2,lon2)[0]
    # print "endnode:",endnode

###
#    for n in G:
#        print n
#    print "path nodes:"
    pathnodes =networkx.dijkstra_path(G, startnode,endnode)
    path = zip([G.node[n]['data'].lat for n in pathnodes], [G.node[n]['data'].lon for n in pathnodes])
    # print path

    # fig, ax = plt.subplots()
    # ax.plot([G.node[n]['data'].lat for n in pathnodes], [G.node[n]['data'].lon for n in pathnodes], '-')
    # ax.scatter([G.node[n]['data'].lat for n in G], [G.node[n]['data'].lon for n in G], s=50)
    # ax.set_aspect('equal')
    # plt.show()

    return path #ordered list of nodes to be visited in order, forming a path
    #print [G.node[n]['data'].lat for n in pathnodes], [G.node[n]['data'].lon for n in pathnodes]
    #print networkx.nx.dijkstra_path_length(G, "3523912036","3523909953")
    #print(networkx.is_connected(G))

    #networkx.draw_networkx(G,with_labels=True)
    #plt.savefig('this.png')
    #plt.show()



    #plt.plot([G.node[n]['data'].lat for n in G], [G.node[n]['data'].lon for n in G], ',')
    #plt.show()

# path = routepath(49.965,-5.215,49.961,-5.201,0.01,500)
# print path
# cProfile.run('routepath(49.965,-5.215,49.961,-5.201,0.01,500)', sort=1)
#high tolerance = look more area, low tolerance = only look at the area between the start and end points.
#high factor = more accurate pollution weight for each route but longer time to run...experiment to find out good values for factor...default value is 1000
