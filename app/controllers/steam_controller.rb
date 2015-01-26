class SteamController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_callback

  API_URL = "https://api.steampowered.com/IDOTA2Match_570/"


  def auth_callback
    auth = request.env['omniauth.auth']

    current_user.update(steam_id: auth.uid,
                        steam_id_32: (auth.uid.to_i - 76561197960265728),
                        steam_nickname: auth.info['nickname'],
                        steam_pic: auth.info['image'])
    flash[:success] = "Successfully synced your Steam account!"

    redirect_to settings_path
  end


  # return JSON list of live league games
  def self.get_live_games
    option = "GetLiveLeagueGames/v1/"
    auth = { query: { key: ENV['STEAM_WEB_API_KEY']}}

    search_url = API_URL + option

    response = HTTParty.get search_url, auth

    JSON.parse(response.body)['result']['games']

  end


  # return JSON list of leagues
  def self.get_leagues

    option = "GetLeagueListing/v1/"

    auth = { query: { key: ENV['STEAM_WEB_API_KEY']}}
    search_url = API_URL + option

    response = HTTParty.get search_url, auth

    JSON.parse(response.body)['result']['leagues'] || nil
  end


  def self.get_match_history(steam_id, start_at_match_id)

    option = "GetMatchHistory/V001/"

    if start_at_match_id
      auth = { query: { account_id: steam_id, start_at_match_id: start, key: ENV['STEAM_WEB_API_KEY']} }
    else
      auth = { query: { account_id: steam_id, key: ENV['STEAM_WEB_API_KEY']}}
    end

    search_url = API_URL + option

    response = HTTParty.get search_url, auth

    JSON.parse(response.body)['result']['matches']
  end


  #return match details for specific match ID
  def self.get_match(match_id)
    option = "GetMatchDetails/V001/"

    auth = { query: { match_id: match_id, key: ENV['STEAM_WEB_API_KEY'] }}

    search_url = API_URL + option

    response = HTTParty.get search_url, auth

    JSON.parse(response.body)['result']
  end

end