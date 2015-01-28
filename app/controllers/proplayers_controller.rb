class ProplayersController < ApplicationController
 
  def index
    @proplayers = Proplayer.all
  end

  def show
    @proplayer = Proplayer.find(params[:id].to_i)
  end

end