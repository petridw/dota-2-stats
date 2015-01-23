class SteamController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_callback


  def auth_callback
    auth = request.env['omniauth.auth']

    current_user.update(steam_id: auth.uid, steam_nickname: auth.info['nickname'], steam_pic: auth.info['image'])

    redirect_to settings_path
  end

end