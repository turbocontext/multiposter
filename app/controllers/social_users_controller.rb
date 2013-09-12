# -*- encoding: utf-8 -*-
class SocialUsersController < ApplicationController

  before_filter :find_social_user, only: [:update, :destroy]

  def index
    @social_users = current_user.social_users.order("social_users.created_at DESC")
  end

  def update
    @social_user.update_attributes(params[:social_user])
    respond_to do |format|
      format.html { redirect_to social_users_path }
      format.json { render nothing: true }
    end
  end

  def create
    # raise request.env['omniauth.auth'].to_yaml
    # raise params.to_yaml
    @social_users = SocialUser.from_omniauth(request.env['omniauth.auth'] || params[:social_user])
    @social_users.each do |social_user|
      if user = current_user.social_users.find_by_uid_and_provider(social_user.uid, social_user.provider)
        user.clone_from(social_user)
        social_user.destroy
      else
        social_user.update_attributes(user_id: current_user.id)
      end
    end
    redirect_to social_users_path
  end

  def vkontakte
    session[:state] = Digest::MD5.hexdigest(rand.to_s)
    @social_user = SocialUser.new
  end

  def livejournal
    @social_user = SocialUser.new
  end

  def google_plus
    @social_user = SocialUser.new
  end

  def odnoklassniki
    @social_user = SocialUser.new
  end

  def destroy
    @social_user.destroy
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def mass_destroy
    if params[:mass_destroy] && params[:mass_destroy][:model_ids]
      ids = params[:mass_destroy][:model_ids].split(',').map(&:to_i)
      SocialUser.where(id: ids).each(&:destroy)
    end
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

private

  def find_social_user
    @social_user = SocialUser.find(params[:id])
  end
end
