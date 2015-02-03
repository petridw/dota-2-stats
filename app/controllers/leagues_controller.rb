class LeaguesController < ApplicationController
  def index
    @leagues = League.all.order_by(last_active: :desc).page(params[:page]).per(ITEMS_PER_PAGE)
  end
end