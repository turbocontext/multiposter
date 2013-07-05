require 'spec_helper'

describe UsersController do
  let(:user) {FactoryGirl.create(:user)}

  before(:each) do
    sign_in user
  end

  describe "GET 'show'" do
    it "should fetch appropriate user" do
      get :show, id: user.id
      assigns(:user).should eq(user)
    end
  end
end
