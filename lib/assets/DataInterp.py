#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

from numpy import array,float64
from scipy.interpolate import interp2d
import pickle

def gen_func(x,y,z):
	x=array(x,dtype=float64)
	y=array(y,dtype=float64)
	z=array(z,dtype=float64)
	f = interp2d(x, y, z, kind='cubic')
	with open('estimated_func.pkl', 'wb') as output:
    		pickle.dump(f, output, pickle.HIGHEST_PROTOCOL)

def load_func(x,y):
	with open('estimated_func.pkl', 'rb') as input:
    		f = pickle.load(input)
	x=array(x,dtype=float64)
	y=array(y,dtype=float64)
	return list(f(x,y))





