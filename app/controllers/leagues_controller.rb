class LeaguesController < ApplicationController
  def index
    @leagues = League.all.order_by(last_active: :desc)
  end
end