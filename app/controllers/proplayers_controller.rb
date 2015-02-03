class ProplayersController < ApplicationController
 
  def index

    #filter should be set to the param but false if param isn't
    @filter = params[:filter]
    @filter ||= false

    @total_tracked_players = Proplayer.count

    if @filter
      authorize
      @proplayers = current_user.proplayers.order_by(tier: :desc, last_active: :desc).page(params[:page]).per(ITEMS_PER_PAGE)
    else
      @proplayers = Proplayer.all.order_by(tier: :desc, last_active: :desc).page(params[:page]).per(ITEMS_PER_PAGE)
    end
  end

  def show
    @proplayer = Proplayer.find(params[:id].to_i)
  end

end