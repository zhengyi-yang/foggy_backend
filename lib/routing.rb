require 'singleton'
require 'rubypython'
require 'pathname'

class Routing
  include Singleton

  def initialize()
    sys=RubyPython.import('sys')
    sys.path.append(get_current_path)
    os=RubyPython.import('os')
    os.chdir(get_current_path)
    @routing_interp=RubyPython.import('routing')
  end

  def get_route(lat_start, long_start, lat_end, long_end)
    route_array = @routing_interp.routepath(lat_start, long_start, lat_end, long_end)
    route = []
    route_array.to_a.each_with_index do |p,i|
      route.push({lat: p[0].to_s, long: p[1].to_s}, order: i.to_s)
    end
    return route
  end

  private
    def get_current_path
      return Pathname.new(File.dirname(__FILE__)).realpath.to_s
    end

end