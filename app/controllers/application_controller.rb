class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def sec_to_str(total_seconds)

    minutes = total_seconds / 60
    seconds = total_seconds % 60

    "#{format('%02d', minutes)}:#{format('%02d', seconds)}"
  end

  def authorize
    unless current_user
      flash[:danger] = "You must login in order to view this page."
      redirect_to login_path
    end
  end

  def auth_steam
    unless current_user.steam_id
      flash[:danger] = "You must sync your steam account in order to get your recent games history"
      redirect_to settings_path
    end
  end
end
