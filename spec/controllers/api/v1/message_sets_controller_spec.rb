require "spec_helper"

describe Api::V1::MessageSetsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @social_user = FactoryGirl.create(:social_user, user: @user)
    @attr = {message:
              {
                short_text: 'short',
                text: 'long',
                url: 'link'
              },
            api_key: @user.api_key
            }

  end
  describe "POST 'create'" do
    it "should find appropriate user" do
      post :create, @attr
      assigns(:user).should eq(@user)
    end
    it "should create some messages" do
      expect do
        post :create, @attr
      end.to change{@user.messages.count}.by(1)
    end
  end
end
