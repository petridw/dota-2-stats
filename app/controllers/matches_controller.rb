class MatchesController < ApplicationController
  def index
    @matches = SteamController.getLiveGames
  end

end