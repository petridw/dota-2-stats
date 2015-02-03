class ProplayersController < ApplicationController
 
  def index

    #filter should be set to the param but false if param isn't
    @filter = params[:filter]
    @filter ||= false

    if @filter
      authorize
      @proplayers = current_user.proplayers.order_by(tier: :desc, last_active: :desc)
    else
      @proplayers = Proplayer.all.order_by(tier: :desc, last_active: :desc)
    end
  end

  def show
    @proplayer = Proplayer.find(params[:id].to_i)
  end

end