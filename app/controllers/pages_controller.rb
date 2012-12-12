class PagesController < ApplicationController
  def index
    @users = SocialUser.scoped
  end
end
