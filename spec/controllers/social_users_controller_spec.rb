require "spec_helper"

describe SocialUsersController do
  before(:each) do
      user = FactoryGirl.create(:user)
      sign_in user
  end

  describe "GET index" do
    it "should fetch all social users and return ok" do
      get :index
      assigns(:users).should == SocialUser.scoped
      response.should be_ok
    end
  end
end
