# -*- encoding: utf-8 -*-
class SocialUsersController < ApplicationController

  def index
    @users = SocialUser.scoped
    @page_header = "Учетные записи социальных сетей"
  end

  def create
    user = SocialUser.from_omniauth(request.env['omniauth.auth'])
    user.update_attributes(user_id: current_user.id) if user
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
