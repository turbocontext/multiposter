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

  describe "GET 'index'" do
    before(:each) do
      @message_set1 = FactoryGirl.create(:message_set, user_id: @user.id)
      @user2 = FactoryGirl.create(:user)
      @message_set2 = FactoryGirl.create(:message_set, user_id: @user2.id)
    end

    it "should fetch all messages from current user" do
      get :index
      assigns(:message_sets).should include(@message_set1)
      assigns(:message_sets).should_not include(@message_set2)
    end
  end

  describe "GET 'new'" do
    it "should return ok" do
      get :new, create_message: {model_ids: "#{@suser1.id},#{@suser2.id}"}
      response.should be_ok
    end

    it "should redirect to root path if there is no social users" do
      SocialUser.scoped.each {|u| u.update_attributes(checked: false)}
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

  describe "POST 'create'" do
    before(:each) do
      @attr = {
        messages_attributes: {
          '0' => {social_user_id: @suser1.id, text: "sand king"},
          '1' => {social_user_id: @suser2.id, text: ''}, # invalid text
          '2' => {social_user_id: @suser3.id, text: 'valid text, but invalid user'}
        }
      }
    end
    it "should create message set" do
      expect {post :create, message_set: @attr}.to change {MessageSet.count}.by(1)
    end

    it "should create new messages" do
      expect {post :create, message_set: @attr}.to change{Message.count}.by(1)
    end

    it "should assign new messages to message set" do
      post :create, message_set: @attr
      message_set = assigns(:message_set)
      Message.last.message_set_id.should == message_set.id
    end

    it "should redirect to social users path" do
      post :create, message_set: @attr
      response.should redirect_to(social_users_path)
    end
  end
end
