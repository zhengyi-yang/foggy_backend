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

	def initialize(longs,lats,aqis)
	#longs -- an array of longitudes of all data points
	#lats -- an array of latitudes of all data points
	#aqis -- an array of AQIs(pollution levels) of all data points
	#Note that at least 16 data points is needed to estimate the function.

		raise ArgumentError, "Arguments must have the same size" unless longs.size==lats.size and lats.size==aqis.size
		raise ArgumentError, "At least 16 data points is required" unless longs.size>=16

		startPy
		interp=RubyPython.import('DataInterp')
		interp.gen_func(longs,lats,aqis)
		stopPy
	end

	def calc(longs,lats)
	#This method computes estimated AQIs of given locations.
	#longs -- an array of longitudes of given locations.
	#lats -- an array of latitudes of given locations.
	#return -- an array of AQIs of given locations.

		startPy
		interp=RubyPython.import('DataInterp')
		aqis=interp.load_func(longs,lats).rubify
		stopPy
		return aqis
	end


	private
	def get_current_path
		return Pathname.new(File.dirname(__FILE__)).realpath.to_s
	end

	private
	def startPy
		RubyPython.start
		sys=RubyPython.import('sys')
		sys.path.append(get_current_path)
		os=RubyPython.import('os')
		os.chdir(get_current_path)
	end
	
	private
	def stopPy
		RubyPython.stop
	end

end




