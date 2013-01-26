require "spec_helper"
require "support/omniauth_examples"

describe SocialUsersController do
  before(:each) do
    user = FactoryGirl.create(:user)
    sign_in user
    @oauth = OmniauthExamples.facebook_oauth
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
    it "should create user from omniauth" do

    end
  end
end
