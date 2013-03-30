# -*- encoding: utf-8 -*-
class SocialUsersController < ApplicationController

  def index
    @users = current_user.social_users
    @page_header = "Учетные записи социальных сетей"
  end

  def create
    # raise request.env['omniauth.auth'].to_yaml
    SocialUser.from_omniauth(request.env['omniauth.auth']).each do |user|
      user.update_attributes(user_id: current_user.id)
    end
    redirect_to root_path
  end

  def destroy
    user = SocialUser.find(params[:id])
    user.destroy
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def mass_destroy
    if params[:mass_destroy] && params[:mass_destroy][:model_ids]
      ids = params[:mass_destroy][:model_ids].split(',').map(&:to_i)
      SocialUser.find_all_by_id(ids).each(&:destroy)
    end
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
