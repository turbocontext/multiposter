require "spec_helper"

describe UserInfo do
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

  it "should extract info from omniauth hash" do
    user_info = UserInfo.new(@oauth1)
    user_info.email.should == @oauth1[:info][:email]
  end

  it "should modify email if there is no email in auth hash" do
    user_info = UserInfo.new(@oauth2)
    user_info.email.should == "official.kavigator@twitter.com"
  end

  it "should raise insufficient info error if auth hash is invalid" do
    expect {UserInfo.new({})}.to raise_error(UserInfo::InsufficientInfoError)
  end

end
