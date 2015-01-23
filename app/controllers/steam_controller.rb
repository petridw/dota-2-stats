class SteamController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_callback

  API_URL = "https://api.steampowered.com/IDOTA2Match_570/"

  def auth_callback
    auth = request.env['omniauth.auth']

    current_user.update(steam_id: auth.uid, steam_nickname: auth.info['nickname'], steam_pic: auth.info['image'])

    redirect_to settings_path
  end

  def self.getLiveGames
    option = "GetLiveLeagueGames/v1/"
    auth = { query: { key: ENV['STEAM_WEB_API_KEY']}}

    search_url = API_URL + option

    response = HTTParty.get search_url, auth

    matchlist = JSON.load(response.body)['result']['games']

  end

end