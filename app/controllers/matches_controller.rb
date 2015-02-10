class MatchesController < ApplicationController

  before_action :authorize, :auth_steam

  def index

    # -----
    # params[:reload] may or may not be given. If it's not given then set reload to false. The reload
    # boolean variable will be passed to the MatchHistoryJob and determines if the user's entire match
    # history should be reloaded.
    # -----
    if params[:reload]
      reload = params[:reload]
      flash[:info] = "Your match data will be resynced! Try refreshing this page in a minute or two. Or a few." 
    else
      reload = false
    end

    # -----
    # @filter should be set to the param but false if param isn't provided. If @filter is true
    # then the only matches displayed will be the user's matches with "proplayers"
    # -----
    @filter = params[:filter]
    @filter ||= false

    # Start an async match history job to fetch and update the user's match data. In the current
    # implementation the page will need to be reloaded for the user to see any new data that is
    # stored from this call.
    MatchHistoryJob.new.async.perform(current_user.steam_id, reload, current_user.id)

    if @filter
      @matches = current_user.matches.where(has_pro: true).order_by(start_time: :desc).page(params[:page]).per(ITEMS_PER_PAGE)
    else
      @matches = current_user.matches.order_by(start_time: :desc).page(params[:page]).per(ITEMS_PER_PAGE)
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

end