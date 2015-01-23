class MatchesController < ApplicationController
  def index
    matches_json = SteamController.get_live_games
    @matches = []

    matches_json.each do |match_json|

      league = League.find(match_json['league_id']) || nil

      match_hash = {
        match_id: match_json['match_id'],
        spectators: match_json['spectators'],
        duration: match_json['scoreboard']['duration'],
        league: league,
        series_type: match_json['series_type'],
        radiant_kills: match_json['scoreboard']['radiant']['score'],
        dire_kills: match_json['scoreboard']['dire']['score']
      }
      @matches.push(match_hash)
    end

  end

  def create

  end

  def update
  end

  def update_match_list
    match_json = SteamController.get_live_games
  end
end