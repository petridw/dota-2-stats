class UsersController < ApplicationController
  before_action :authorize, only: [:settings]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id.to_s
      redirect_to home_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to home_path
    end

    # Not sure what to do if User can't be updated
    # since I don't have an edit page
    # normally would do a render :edit
  end

  def settings
    @user = current_user
  end

  def updatesteam
    @user = current_user

    if @user.update(params.permit(:steam_id))
      redirect_to settings_path
    else
      render :settings
    end
  end

  def unlinkSteam
    current_user.update(steam_id: nil, steam_pic: nil, steam_nickname: nil)

    redirect_to settings_path
  end


  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

end
