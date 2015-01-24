class MatchesController < ApplicationController

  before_action :authorize, only: :mygames


  def index
    matches_json = SteamController.get_live_games
    @matches = []

    matches_json.each do |match_json|

      league = League.find(match_json['league_id']) || nil

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
    # @match = SteamController.
  end


  def mygames
    if current_user.steam_id
      matches_json = SteamController.get_match_history(current_user.steam_id)

      @matches = []
      lobby_types = [ 
                      "Public matchmaking",
                      "Practice",
                      "Tournament",
                      "Tutorial",
                      "Co-op with bots",
                      "Team match",
                      "Solo Queue",
                      "Ranked",
                      "Solo Mid 1vs1"
                    ]

      matches_json.each do |match_json|

        start_time = Time.at(match_json['start_time']).strftime("%d/%m/%Y")

        match_hash = {
          match_id: match_json['match_id'],
          start_time: start_time,
          lobby_type: lobby_types[match_json['lobby_type']]
        }

        @matches.push(match_hash)
      end
    else
      flash[:danger] = "You must sync your steam account in order to get your recent games history"
      redirect_to settings_path
    end
  end


  def update_match_list
    match_json = SteamController.get_live_games
  end


  def sec_to_str(total_seconds)

    str = ""

    minutes = total_seconds / 60
    seconds = total_seconds % 60

    "#{format('%02d', minutes)}:#{format('%02d', seconds)}"
  end
end