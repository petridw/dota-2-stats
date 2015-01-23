class SteamController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_callback

  API_URL = "https://api.steampowered.com/IDOTA2Match_570/"

  def auth_callback
    auth = request.env['omniauth.auth']

    current_user.update(steam_id: auth.uid, steam_nickname: auth.info['nickname'], steam_pic: auth.info['image'])

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

end