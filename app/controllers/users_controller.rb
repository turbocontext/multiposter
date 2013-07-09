class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user] && params[:user][:language]
      @user.language = params[:user][:language]
      @user.save!
    end
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to users_path(current_user)
  end
end
