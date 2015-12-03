#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

from numpy import array,float16,meshgrid,isnan
from scipy.interpolate import CloughTocher2DInterpolator
import pickle

def gen_func(x,y,z):
    #ziped_xyz=zip(zip(x,y),z)
    #ziped_xyz=[x for x in ziped_xyz if x[1]!=0]
    #unziped_xyz=zip(*ziped_xyz)
    #points=array(unziped_xyz[0],dtype=float64)
    #z=array(unziped_xyz[1],dtype=float64)
    points=array(zip(x,y),dtype=float16)
    z=array(z,dtype=float16)

    # print points
    # print z
        
    f = CloughTocher2DInterpolator(points,z)#Clough-Tocher method
    with open('estimated_func.pkl', 'wb') as output:
        pickle.dump(f, output, pickle.HIGHEST_PROTOCOL)
    
    #print f(x,y)
    #make_graph(x,y,z)

def load_func(x,y,isCoord=False):
    with open('estimated_func.pkl', 'rb') as input:
        f = pickle.load(input)
    x=array(x,dtype=float16)
    y=array(y,dtype=float16)
    if isCoord:
        xx,yy=meshgrid(x,y)
        ans=f(xx,yy)
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

'''
# a=array([[  0.177891  ,  51.563752  ],
#  [  0.132857  ,  51.529389  ],
#  [  0.18740488 , 51.47819351],
#  [  0.19083623 , 51.4776708 ],
#  [  0.13727911  ,51.49464868],
#  [  0.15891449  ,51.49061021],
#  [  0.18487713  ,51.46598327],
#  [  0.085606    ,51.4563    ],
#  [ -0.258089    ,51.552476  ],
#  [ -0.248774    ,51.552656  ],
#  [ -0.247793    ,51.537799  ],
#  [ -0.125848    ,51.522287  ],
#  [ -0.175284    ,51.544219  ],
#  [ -0.127027    ,51.515532  ],
#  [ -0.12905321  ,51.52770662],
#  [ -0.12019471  ,51.51736751],
#  [ -0.10451563  ,51.51452534]])

# x=[0.177891, 0.132857, 0.187404883999095, 0.190836225974902, 0.137279111232178, 0.158914493927518, 0.184877126994369, 0.085606, -0.258089, -0.248774, -0.247793, -0.125848, -0.175284, -0.127027, -0.129053205282516, -0.1201947113171, -0.104515626337876]
# y=[51.563752, 51.529389, 51.4781935083933, 51.477670796298, 51.4946486813055, 51.4906102082147, 51.4659832746662, 51.4563, 51.552476, 51.552656, 51.537799, 51.522287, 51.544219, 51.515532, 51.5277066194645, 51.5173675146177, 51.5145253362314]
# z=[ 2  ,2,  1,  1,  3 , 1 , 3 , 2 , 3 , 1 , 3 , 3 , 3 , 2 , 2 , 2 , 1]


# x1=[];y1=[];

# ii = -1
# for i in a:
#     ii = ii+1
#     print ii, x[ii], i[0], y[ii], i[1]

# gen_func(x,y,z)
# print load_func(x,y)
# print z
# print load_func(0.18487713, 51.46598327)
# #print load_func(0.5,0.5)

# #make_graph(x,y,z)

