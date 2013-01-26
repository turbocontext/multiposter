require "spec_helper"
require "support/omniauth_examples"

describe SocialUser do
  before(:each) do
    @attr = {
      uid: "ddd",
      provider: "snd",
      access_token: "secret",
      secret_token: "secrete",
      user_id: "12",
      email: "email@email.com"
    }
    @oauth1 = OmniauthExamples.facebook_oauth
    @oauth2 = OmniauthExamples.twitter_oauth
  end
  it "should create new social user with valid attributes" do
    SocialUser.create(@attr).should be_true
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
    it "should have many message sets and messages through it" do
      SocialUser.new.should respond_to(:message_sets)
      SocialUser.new.should respond_to(:messages)
    end
  end

  describe "from omniauth" do
    it "should create new user from omniauth" do
      expect {SocialUser.from_omniauth(@oauth1)}.to change(SocialUser, :count).by(1)
    end

    it "should update user's access token if it was changed" do
      new_token = "new token"
      new_auth = @oauth1.deep_merge({provider: 'facebook', info: {email: "example@mail.com"}, credentials: {token: new_token}})
      user1 = FactoryGirl.create(:social_user, email: "example@mail.com", provider: "facebook", access_token: "old token")
      expect {SocialUser.from_omniauth(new_auth); user1.reload}.to \
        change(user1, :access_token).to(new_token)
    end

    it "should return nil when auth hash is invalid or corrupted" do
      SocialUser.from_omniauth(nil).should be_nil
    end
  end

  describe UserInfo do
    it "should extract info from omniauth hash" do
      user_info = UserInfo.new(@oauth1)
      user_info.email.should == @oauth1[:info][:email]
    end

    it "should modify email if there is no email in auth hash" do
      user_info = UserInfo.new(@oauth2)
      user_info.email.should == "offical.kavigator@twitter.com"
    end

    it "should raise insufficient info error if auth hash is invalid" do
      expect {UserInfo.new({})}.to raise_error(InsufficientInfoError)
    end
  end
end
