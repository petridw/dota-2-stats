class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])

    if @user
      if @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id.to_s
        flash[:info] = "You have successfully logged in."
        redirect_to root_path
      else
        @user = User.new(username: params[:user][:username])
        @user.errors.add(:password, "Incorrect password")
        render :new
      end
    else
      @user = User.new(username: params[:user][:username])
      @user.errors.add(:username, "User ID not found")
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You have successfully logged out. Goodbye!"
    redirect_to login_path
  end
end
