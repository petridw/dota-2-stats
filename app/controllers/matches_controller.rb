class MatchesController < ApplicationController
  def index
    @matches = update_match_list
  end

  def create

  end

  def update
  end

  def update_match_list
    match_list = SteamController.get_live_games

  end
end