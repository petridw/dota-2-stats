class SteamController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_callback


  def auth_callback
    auth = request.env['omniauth.auth']

    session[:steam_user] = { nickname: auth.info['nickname'],
                             image: auth.info['image'],
                             steam_id: auth.uid }

    redirect_to user_update_steam_path(current_user.id)
  end

end