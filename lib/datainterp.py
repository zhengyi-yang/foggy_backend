#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

from numpy import array,float64,meshgrid,isnan
from scipy.interpolate import CloughTocher2DInterpolator
import pickle

def gen_func(x,y,z):
    ziped_xyz=zip(zip(x,y),z)
    ziped_xyz=[x for x in ziped_xyz if x[1]!=0]
    unziped_xyz=zip(*ziped_xyz)
    points=array(unziped_xyz[0],dtype=float64)
    z=array(unziped_xyz[1],dtype=float64)
    
    #file=open('datainterp_debug.txt','w')
    #file.write(str(points)+"\n\n"+str(z)+"\n\n")
        
	f = CloughTocher2DInterpolator(points,z)#Clough-Tocher method
	with open('estimated_func.pkl', 'wb') as output:
    		pickle.dump(f, output, pickle.HIGHEST_PROTOCOL)
    #file.write(str(f(array(x),array(y))))	
    #file.close()

def load_func(x,y,isCoord=False):
	with open('estimated_func.pkl', 'rb') as input:
    		f = pickle.load(input)
	x=array(x,dtype=float64)
	y=array(y,dtype=float64)
	if isCoord:
		xx,yy=meshgrid(x,y)
                ans=f(xx,yy).tolist
	else:
                ans=f(x,y)
	ans=ans.tolist()
	return ans

'''
def make_graph(lon=None,lat=None,aqi=None):
        from mpl_toolkits.mplot3d import axes3d
        from numpy import random,linspace,array
        from matplotlib import pyplot as plt

        if(lon==None or lat==None or aqi==None):
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


a=array([[ 51.563752  ,   0.177891  ,   1.        ],
       [ 51.529389  ,   0.132857  ,   1.        ],
       [ 51.49464868,   0.13727911,   2.        ],
       [ 51.46598327,   0.18487713,   2.        ],
       [ 51.49061021,   0.15891449,   1.        ],
       [ 51.4563    ,   0.085606  ,   2.        ],
       [ 51.552476  ,  -0.258089  ,   2.        ],
       [ 51.537799  ,  -0.247793  ,   2.        ],
       [ 51.522287  ,  -0.125848  ,   2.        ],
       [ 51.544219  ,  -0.175284  ,   2.        ]])

x=[];y=[];z=[]

for i in a:
  x.append(i[0])
  y.append(i[1])
  z.append(i[2])

gen_func(x,y,z)
print load_func(x,y)
print z
print load_func(0.5,0.5)

make_graph(x,y,z)
'''


