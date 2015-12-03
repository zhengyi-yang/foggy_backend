#Author: Zhengyi Yang
#Created on Fri 20 Nov, 2015

require 'singleton'
require 'rubypython'
require 'pathname'

class DataInterp
#This class performs a 2-dimensional Clough-Tocher interpolation on a given dataset.
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

  include Singleton

  def initialize()
  #This method creates a new DataInterp instance.
  #longs -- an array of longitudes of all data points
  #lats -- an array of latitudes of all data points
  #aqis -- an array of AQIs(pollution levels) of all data points
    @isRunning=false
    pollution = Pollution.all
    if(pollution==nil)
      warn('warning: initializing DataInterp with no parameters, latest function will be loaded.')
      start
      return
    end
    start
    update(pollution)
  end
  
  def update(pollution)#Update all data points
    longitudes = pollution.map {|p| p.longitude}
    latitudes = pollution.map {|p| p.latitude}
    indexs = pollution.map {|p| p.index}
    @interp.gen_func(longitudes, latitudes, indexs)
  end

  def calc(longs,lats,isCoord=false)
  #This method computes estimated AQIs of given locations.
  #longs -- an array of longitudes of given locations.
  #lats -- an array of latitudes of given locations.
  #isCoord --true if longs and lats are axies
  #return -- an array of AQIs of given locations.
    raise RuntimeError,"Python interperter has been stopped" unless @isRunning
    raise ArgumentError, "Arguments must have the same size" unless longs.size==lats.size
    aqis=@interp.load_func(longs,lats,isCoord).rubify
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

