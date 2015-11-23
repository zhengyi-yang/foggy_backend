#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

from numpy import array,float64,diagonal
from scipy.interpolate import interp2d
import pickle

def gen_func(x,y,z):
	x=array(x,dtype=float64)
	y=array(y,dtype=float64)
	z=array(z,dtype=float64)
	f = interp2d(x, y, z, kind='cubic')
	with open('estimated_func.pkl', 'wb') as output:
    		pickle.dump(f, output, pickle.HIGHEST_PROTOCOL)

def load_func(x,y,isCoord=False):
	with open('estimated_func.pkl', 'rb') as input:
    		f = pickle.load(input)
	x=array(x,dtype=float64)
	y=array(y,dtype=float64)
	ans=f(x,y)
	if isCoord:
		return ans.tolist()
	else:
		return diagonal(ans).tolist()


