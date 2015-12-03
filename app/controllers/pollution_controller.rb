class PollutionController < ApplicationController
  require 'datainterp'

  def get_pollution
    if !params[:lat] or !params[:long]
      head 400
    else
      datainterp = DataInterp.instance
      result = datainterp.calc([params[:lat]], [params[:long]], true)[0].to_s
      pollution = {lat: params[:lat], long: params[:long], index: result}
      render json: pollution
    end
  end

  private
    def pollution_params
      params.require(:lat).require(:long)
    end
end
