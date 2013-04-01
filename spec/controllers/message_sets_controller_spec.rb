#-*- encoding: utf-8 -*-
require "spec_helper"

describe MessageSetsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    sign_in(@user)
    @suser1 = FactoryGirl.create(:social_user, user_id: @user.id)
    @suser2 = FactoryGirl.create(:social_user, user_id: @user.id)
    @suser3 = FactoryGirl.create(:social_user, user_id: @user2.id)
  end

  describe "GET 'new'" do
    it "should return ok" do
      get :new, model_ids: "1,2,3"
      response.should be_ok
    end

    it "should redirect to root path if there is no social users" do
      get :new
      response.should redirect_to(root_path)
      get :new, model_ids: "#{@suser3.id}"
      response.should redirect_to(root_path)
    end

    it "should fetch all social users from current user" do
      get :new, model_ids: [@suser1.id, @suser2.id, @suser3.id].join(',')
      assigns(:social_users).should == [@suser1, @suser2]
    end
  end
end