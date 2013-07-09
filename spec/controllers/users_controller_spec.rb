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

  describe "PUT 'update'" do
    it "should change user's language" do
      put :update, id: user.id, user: {language: 'ru'}
      assigns(:user).should == user
      assigns(:user).language.should == 'ru'
    end
  end
end
