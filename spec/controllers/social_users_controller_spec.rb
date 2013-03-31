# -*- encoding: utf-8 -*-
require "spec_helper"
require "support/omniauth_examples"

describe SocialUsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "should fetch all social users and return ok" do
      get :index
      assigns(:users).should == SocialUser.scoped
      response.should be_ok
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @social_user = FactoryGirl.create(:social_user)
    end
    it "should destroy given social user" do
      expect {delete :destroy, id: @social_user.id }.to \
        change(SocialUser, :count).by(-1)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @oauth = OmniauthExamples.test_oauth
      request.env['omniauth.auth'] = @oauth
    end

    it "should not create anything withou proper oauth hash" do
      expect do
        SocialUser.stub(:from_omniauth).and_return([])
        post :create
      end.not_to change {SocialUser.count}
    end

    it "should create user from omniauth" do
      expect do
        SocialUser.stub(:from_omniauth).and_return([FactoryGirl.create(:social_user)])
        post :create
      end.to change {SocialUser.count}.by(1)
    end

    it "should assign created users to current user" do
      SocialUser.stub(:from_omniauth).and_return([FactoryGirl.create(:social_user, user_id: nil)])
      post :create
      assigns(:social_users).each {|u| u.reload; u.user_id.should eq(@user.id)}
      response.should redirect_to(root_path)
    end

    it "should just update records if there is similar uid and user_id" do
      expect do
        u1 = FactoryGirl.create(:social_user, user_id: @user.id, uid: "123", access_token: "old token")
        u2 = FactoryGirl.create(:social_user, user_id: nil, uid: "123", access_token: "new token")
        u3 = FactoryGirl.create(:social_user, user_id: @user.id, access_token: "new token")
        SocialUser.stub(:from_omniauth).and_return([u2, u3])
        post :create
        u1.reload
        u1.access_token.should == "new token"
        u1.user_id.should == @user.id
      end.to change{SocialUser.count}.by(1)
    end
  end

  describe "DELETE 'mass_destroy'" do
    it "should delete given social users" do
      user1 = FactoryGirl.create(:social_user)
      user2 = FactoryGirl.create(:social_user)
      expect {delete :mass_destroy, mass_destroy: {model_ids: "#{user1.id},#{user2.id}"}}.to change(SocialUser, :count).by(-2)
    end
  end
end
