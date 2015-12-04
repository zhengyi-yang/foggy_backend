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

