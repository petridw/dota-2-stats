class SessionsController < ApplicationController

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id.to_s
      redirect_to home_path
    else
      render '/sessions/new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
