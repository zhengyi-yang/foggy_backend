class PollutionController < ApplicationController
  require 'datainterp'

  def get_pollution
    if !params[:lat] or !params[:long]
      head :unprocessable_entity
    else
      datainterp = DataInterp.instance
      result = datainterp.calc(params[:long], params[:lat]).to_s
      pollution = {lat: params[:lat], long: params[:long], index: result.to_s}
      render json: pollution
    end
  end

  private
    def pollution_params
      params.require(:lat).require(:long)
    end
end
