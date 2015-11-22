#Author: Zhengyi Yang
#Date: 20 Nov, 2015

require 'rubypython'

class DataInterp
#This class performs a 2 dimensional cubic spline interpolation on a given dataset.
#The interpolation is supported by Python(version 2.x) SciPy library and a Ruby-Python 
#bridge is built using rubypython.
#Please try the following commands to install these libraries: 
# $: pip install numpy
# $: pip install scipy
# $: gem install rubypython 

	def initialize(longs,lats,aqis)
	#This method creates a new DataInterp instance.
	#longs -- an array of longitudes of all data points
	#lats -- an array of latitudes of all data points
	#aqis -- an array of AQIs(pollution levels) of all data points
	#Note that at least 16 data points is needed to estimate the function.
	
		raise ArgumentError, "Arguments must have the same size" unless longs.size==lats.size and lats.size==aqis.size
		raise ArgumentError, "At least 16 data points is required" unless longs.size>=16

		RubyPython.start
		interp=RubyPython.import("2d_interpolation")
		interp.gen_func(longs,lats,aqis)
		RubyPython.stop
	end

	def calc(longs,lats)
	#This method computes estimated AQIs of given locations.
	#longs -- an array of longitudes of given locations.
	#lats -- an array of latitudes of given locations.
	#return -- an array of AQIs of given locations.

		RubyPython.start
		interp=RubyPython.import("2d_interpolation")
		aqis=interp.load_func(longs,lats).rubify
		RubyPython.stop
		return aqis
	end
	
end


