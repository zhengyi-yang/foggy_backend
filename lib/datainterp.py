#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

from numpy import array,float64,meshgrid,isnan
from scipy.interpolate import CloughTocher2DInterpolator
import pickle

def gen_func(x,y,z):
    points=array(zip(x,y),dtype=float64)
    z=array(z,dtype=float64)
    f = CloughTocher2DInterpolator(points,z)#Clough-Tocher method
    with open('estimated_func.pkl', 'wb') as output:
        pickle.dump(f, output, pickle.HIGHEST_PROTOCOL)
    #make_graph(x,y,z)

def load_func(x,y,isCoord=False):
    with open('estimated_func.pkl', 'rb') as input:
        f = pickle.load(input)
    x=array(x,dtype=float64)
    y=array(y,dtype=float64)
    if isCoord:
        xx,yy=meshgrid(x,y)
        ans=f(xx,yy)
        # print 'Ans:'
        # print ans
    else:
        ans=f(x,y)
    ans=ans.tolist()
    return [x if not isnan(x) else 0 for x in ans]

'''
def make_graph(lon=None,lat=None,aqi=None):
        from mpl_toolkits.mplot3d import axes3d
        from numpy import random,linspace
        from matplotlib import pyplot as plt

        if(x==None or y==None or z==None):
            lon=50+random.rand(20)
            lat=random.rand(20)
            aqi=random.randint(1,3,20)
        gen_func(lon,lat,aqi)

        min_lon,max_lon=min(lon),max(lon)
        min_lat,max_lat=min(lat),max(lat)

        x=linspace(min_lon,max_lon,100)
        y=linspace(min_lat,max_lat,100)
        xx,yy=meshgrid(x,y)

        z=load_func(xx,yy)

        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        #ax.set_zlim(0,9)
        ax.plot(lon,lat,aqi,'ro')
        ax.plot_surface(xx,yy,z,rstride=2,cstride=2,cmap=plt.cm.coolwarm,alpha=0.8)
        ax.set_xlabel('longitude')
        ax.set_ylabel('latitude')
        ax.set_zlabel('aqi')

        plt.show()
'''

