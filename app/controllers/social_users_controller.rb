class SocialUsersController < ApplicationController

  def create
    user = SocialUser.from_omniauth(request.env['omniauth.auth'], current_user)
    redirect_to root_path
  end

  def mass_destroy
    raise params.to_yaml
  end
end
