require "spec_helper"
require "support/omniauth_examples"

describe SocialUser do
  before(:each) do
    @attr = {
      uid: "ddd",
      provider: "test_provider",
      access_token: "secret",
      secret_token: "secrete",
      user_id: "12",
      email: "email@email.com",
      nickname: "ddd"
    }
    @oauth1 = OmniauthExamples.facebook_oauth
    @oauth2 = OmniauthExamples.twitter_oauth
  end

  it "should create new social user with valid attributes" do
    expect{SocialUser.create(@attr)}.to change{SocialUser.count}.by(1)
  end

  describe "methods" do
    it "should should have ancestry" do
      SocialUser.roots.should be_true
    end
  end

  describe "validations" do
    it "should reject records without provider" do
      SocialUser.new(@attr.merge(provider: nil)).should_not be_valid
    end

    it "should reject records without access token" do
      SocialUser.new(@attr.merge(access_token: nil)).should_not be_valid
    end
  end

  describe "relations" do
    it "should have many messages" do
      SocialUser.new.should respond_to(:messages)
    end
  end

  describe "from omniauth" do
    before(:each) do
      @info = UserInfo.new(@oauth1)
    end
    it "should create new user from omniauth" do
      expect {SocialUser.from_omniauth(@info)}.to change(SocialUser, :count).by(1)
    end

    it "should update user's access token if it was changed" do
      new_token = "new token"
      new_info = UserInfo.new(@oauth1.deep_merge({uid: "new_uid", provider: 'facebook', credentials: {token: new_token}}))
      user1 = FactoryGirl.create(:social_user, uid: "new_uid", provider: "facebook", access_token: "old token")
      expect do
        SocialUser.from_omniauth(new_info); user1.reload
      end.to change(user1, :access_token).to(new_token)
    end

  end

end
