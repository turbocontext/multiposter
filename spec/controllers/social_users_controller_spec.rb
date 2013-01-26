require "spec_helper"
require "support/omniauth_examples"

describe SocialUsersController do
  before(:each) do
    user = FactoryGirl.create(:user)
    sign_in user
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
      @oauth = OmniauthExamples.facebook_oauth
    end

    it "should not create anything withou proper oauth hash" do
      expect {post :create}.not_to change(SocialUser, :count)
    end

    it "should create user from omniauth" do
      request.env['omniauth.auth'] = @oauth
      post :create
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
