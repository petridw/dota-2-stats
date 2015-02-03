class MatchesController < ApplicationController

  before_action :authorize, :auth_steam

  def index

    if params[:reload]
      reload = params[:reload]
      flash[:info] = "Your match data will be resynced! Try refreshing this page in a minute or two. Or a few." 
    else
      reload = false
    end

    #filter should be set to the param but false if param isn't
    @filter = params[:filter]
    @filter ||= false

    #REALLY, INDEX SHOULD JUST:
    # 1: kick off job to history_job that says "GET MY HISTORY PLS"
    # 2: get all games in match database for user
    # 3: display them if they are there

    MatchHistoryJob.new.async.perform(current_user.steam_id, reload, current_user.id)

    # matches_json = SteamController.get_match_history(current_user.steam_id, nil)

    # @matches = []

    # if matches_json

    #   matches_json.each do |match_json|
    #     match = Match.find(match_json['match_id'])

    #     if match == nil || reload

    #       MatchJob.new.async.perform(match_json['match_id'], reload)

    #       error = match_json['match_id']
    #       match = Match.new(error: error)
    #     end

    #     @matches.push(match)
    #   end

    # else
    #   flash[:danger] = "Could not load match data for Steam ID #{current_user.steam_id}. You probably need to enable sharing of match history in your Dota 2 options."
    # end

    if reload
      redirect_to matches_path
    else
      @matches = []
      Match.all.order_by(start_time: :desc).each do |m|
        @matches.push(m) if m.players.find(current_user.steam_id_32.to_i) && (!@filter || m.has_pro)
      end
      
    end

  end


  def show

    @match = Match.find(params[:id].to_i)

    if @match == nil

      # match_json = SteamController.get_match(params[:id])
      # MatchWorker.perform_async(params[:id])
      MatchJob.new.async.perform(params[:id])
      flash[:warning] = "Match #{params[:id]} is not yet in the database, but has been added to the queue for download. Please try again soon!"
      redirect_to matches_path

    end

  end

  def pro
    #find games vs or with pro players only
    # matches_json = SteamController.get_match_history(current_user.steam_id, nil)

    # @matches = []

    @matches = []
    Match.all.order_by(start_time: :desc).each do |m|
      @matches.push(m) if m.players.find(current_user.steam_id_32.to_i) && m.has_pro
    end

    # if matches_json
    #   matches_json.each do |match_json|

    #     match = Match.find(match_json['match_id'])

    #     if match == nil
    #       MatchJob.new.async.perform(match_json['match_id'], true, current_user.id)
    #     else
    #         @matches.push(match) if match.has_pro
    #     end

    #   end
    # else
    #   flash[:danger] = "Could not load match data for Steam ID #{current_user.steam_id}. You probably need to enable sharing of match history in your Dota 2 options."
    # end
    render :index
  end


end