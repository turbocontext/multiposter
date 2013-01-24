class SocialUsersController < ApplicationController

  def index
    @users = SocialUser.scoped
  end

  def create
    user = SocialUser.from_omniauth(request.env['omniauth.auth'], current_user)
    redirect_to root_path
  end

  def destroy
    user = SocialUser.find(params[:id])
    user.destroy
    redirect_to :back
  end

  def mass_destroy
    if params[:mass_destroy] && params[:mass_destroy][:model_ids]
      ids = params[:mass_destroy][:model_ids].split(',').map(&:to_i)
      SocialUser.find_all_by_id(ids).each(&:destroy)
    end
    redirect_to :back
  end
end
