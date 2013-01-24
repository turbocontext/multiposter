require "spec_helper"

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

end
