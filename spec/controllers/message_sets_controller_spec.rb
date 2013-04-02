#-*- encoding: utf-8 -*-
require "spec_helper"

describe MessageSetsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    sign_in(@user)
    @suser1 = FactoryGirl.create(:social_user, provider: "provider1", user_id: @user.id)
    @suser2 = FactoryGirl.create(:social_user, provider: "provider2", user_id: @user.id)
    # suser3 belongs to another user!
    @suser3 = FactoryGirl.create(:social_user, user_id: @user2.id)
  end

  describe "GET 'new'" do
    it "should return ok" do
      get :new, create_message: {model_ids: "#{@suser1.id},#{@suser2.id}"}
      response.should be_ok
    end

    it "should redirect to root path if there is no social users" do
      get :new
      response.should redirect_to(root_path)
      get :new, create_message: { model_ids: "#{@suser3.id}" }
      response.should redirect_to(root_path)
    end

    it "should fetch all social users from current user" do
      get :new, create_message: { model_ids: [@suser1.id, @suser2.id, @suser3.id].join(',') }
      assigns(:social_users).should include(@suser2, @suser1)
    end

    it "should prebuild messages with given social users" do
      get :new, create_message: { model_ids: [@suser1.id, @suser2.id, @suser3.id].join(',') }
      assigns(:message_set).messages.length.should == 2
      assigns(:message_set).messages.each do |message|
        [@suser1.id, @suser2.id].should include(message.social_user_id)
      end
    end

    it "should get common types from messages" do
      get :new, create_message: { model_ids: [@suser1.id, @suser2.id, @suser3.id].join(',') }
      assigns(:common_types).should include("provider1", "provider2")
    end
  end
end
