class LivematchesController < ApplicationController


  def index
    matches_json = SteamController.get_live_games
    @matches = []

    matches_json.each do |match_json|

      league = League.find(match_json['league_id']) || nil

      League.update_leagues unless league

      if match_json['scoreboard']
        radiant_kills = match_json['scoreboard']['radiant']['score']
        dire_kills = match_json['scoreboard']['dire']['score']
        duration = sec_to_str(match_json['scoreboard']['duration'].to_i)
      else
        duration = "Pre-game"
        radiant_kills = 0
        dire_kills = 0
      end


      match_hash = {
        match_id: match_json['match_id'],
        spectators: match_json['spectators'],
        duration: duration,
        league: league,
        series_type: match_json['series_type'],
        radiant_kills: radiant_kills,
        dire_kills: dire_kills
      }

      @matches.push(match_hash)

    end
  end

  def show

  end

end