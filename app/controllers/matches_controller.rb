class MatchesController < ApplicationController

  before_action :authorize, :auth_steam

  LOBBY_TYPES = [ 
                  "Public matchmaking",
                  "Practice",
                  "Tournament",
                  "Tutorial",
                  "Co-op with bots",
                  "Team match",
                  "Solo Queue",
                  "Ranked madness",
                  "Solo Mid 1vs1"
                ]

  def index

    matches_json = SteamController.get_match_history(current_user.steam_id, nil)

    @matches = []

    matches_json.each do |match_json|

      match = Match.find(match_json['match_id'])
      if match == nil
        # match_details = SteamController.get_match(match_json['match_id'])
        # add_match(match_details)
      end

      start_time = Time.at(match_json['start_time']).strftime("%m/%d/%Y")

      match_hash = {
        match_id: match_json['match_id'],
        start_time: start_time,
        lobby_type: LOBBY_TYPES[match_json['lobby_type']]
      }

      @matches.push(match_hash)
    end

  end


  def show

    @match = Match.find(params[:id].to_i)

    if @match == nil

      # match_json = SteamController.get_match(params[:id])
      MatchWorker.perform_async(params[:id])
      flash[:warning] = "This match is not yet in the database, but has been added to the queue for download. Please try again soon!"
      redirect_to matches_path

    end


  end


end