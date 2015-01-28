class ProplayersController < ApplicationController
 
  def index
    @proplayers = Proplayer.all.order_by(tier: :desc, last_active: :desc)
  end

  def show
    @proplayer = Proplayer.find(params[:id].to_i)
  end

end