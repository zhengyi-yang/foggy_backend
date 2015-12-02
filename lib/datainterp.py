#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

from numpy import array,float64,meshgrid
from scipy.interpolate import CloughTocher2DInterpolator
import pickle

def gen_func(x,y,z):
        points=array(zip(x,y),dtype=float64)
        z=array(z,dtype=float64)
	f = CloughTocher2DInterpolator(points,z)
	with open('estimated_func.pkl', 'wb') as output:
    		pickle.dump(f, output, pickle.HIGHEST_PROTOCOL)

def load_func(x,y,isCoord=False):
	with open('estimated_func.pkl', 'rb') as input:
    		f = pickle.load(input)
	x=array(x,dtype=float64)
	y=array(y,dtype=float64)
	if isCoord:
		xx,yy=meshgrid(x,y)
                ans=f(xx,yy)
	else:
                ans=f(x,y)
	return ans.tolist()
