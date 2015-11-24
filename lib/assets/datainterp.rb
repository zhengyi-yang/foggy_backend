#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

require 'rubypython'
require 'pathname'

class DataInterp
#This class performs a 2-dimensional cubic spline interpolation on a given dataset.
#The interpolation is supported by Python(version 2.x) SciPy library and a Ruby-Python 
#bridge is built using rubypython.
#Please try the following commands to install these libraries: 
# $: pip install numpy
# $: pip install scipy
# $: gem install rubypython
#Example:
# interp=DataInterp.new(x,y,z)
# aqi=interp.clac(i,j)
# interp.stop

	def initialize(longs=nil,lats=nil,aqis=nil)
	#This method creates a new DataInterp instance.
	#longs -- an array of longitudes of all data points
	#lats -- an array of latitudes of all data points
	#aqis -- an array of AQIs(pollution levels) of all data points
	#Note that at least 16 data points is needed to estimate the function.
		@isRunning=false
		if(longs==nil and lats==nil and aqis==nil)
			warn('warning: initializing DataInterp with no parameters, latest function will be loaded.')
			start
			return
		end
		start
		raise ArgumentError, "Arguments must have the same size" unless longs.size==lats.size and lats.size==aqis.size
		raise ArgumentError, "At least 16 data points is required" unless longs.size>=16
		@interp.gen_func(longs,lats,aqis)
	end

	def calc(longs,lats,isCoord=false)
	#This method computes estimated AQIs of given locations.
	#longs -- an array of longitudes of given locations.
	#lats -- an array of latitudes of given locations.
	#isCoord --true if longs and lats are axies
	#return -- an array of AQIs of given locations.
		raise RuntimeError,"Python interperter has been stopped" unless @isRunning
		raise ArgumentError, "Arguments must have the same size" unless longs.size==lats.size
		aqis=@interp.load_func(longs,lats,isCoord).to_a
		return aqis
	end
	
	def stop
	#Stop external Python interperter
	#Remember to stop Python interperter if the interpolation is no longer needed
	#Due to high likelihood of segementation fault, you cannot restart the Python
	#interperter anagin after stopping it.
		flag=RubyPython.stop
		raise RuntimeError,"Fail to stop python interperter" unless flag
		@isRunning=false
	end

	private
	def get_current_path
		return Pathname.new(File.dirname(__FILE__)).realpath.to_s
	end
	
	def start
	#Start external Python interperter
	#Note that this method is private to prevent segementation fault.
		flag=RubyPython.start
		raise RuntimeError,"Fail to start python interperter" unless flag
		@isRunning=true
		sys=RubyPython.import('sys')
		sys.path.append(get_current_path)
		os=RubyPython.import('os')
		os.chdir(get_current_path)
		@interp=RubyPython.import('datainterp')
	end
end

