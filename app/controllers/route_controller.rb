class RouteController < ApplicationController
  require 'routing'

  def get_route
    puts params
    if !params[:lat_start] or !params[:long_start] or !params[:lat_end] or !params[:long_end]
      head :unprocessable_entity
    else
      routing = Routing.instance
      route = routing.get_route(params[:lat_start].to_f, params[:long_start].to_f, params[:lat_end].to_f, params[:long_end].to_f)
      render json: route
    end
  end
end
