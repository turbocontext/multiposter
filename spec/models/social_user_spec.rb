require "spec_helper"
require "ostruct"
require "support/omniauth_examples"

describe SocialUser do
  before(:each) do
    @attr = {
      uid: "ddd",
      provider: "test_provider",
      access_token: "access",
      secret_token: "secret",
      user_id: "12",
      email: "email@email.com",
      nickname: "ddd"
    }
  end

  it "should create new social user with valid attributes" do
    expect{SocialUser.create(@attr)}.to change{SocialUser.count}.by(1)
  end

  describe "validations" do
    it "should reject records without provider" do
      SocialUser.new(@attr.merge(provider: nil)).should_not be_valid
    end

    it "should reject records without access token" do
      SocialUser.new(@attr.merge(access_token: nil)).should_not be_valid
    end

    it "should reject records without uid" do
      SocialUser.new(@attr.merge(uid: nil)).should_not be_valid
    end
  end

  describe "relations" do
    it "should have many messages" do
      SocialUser.new.should respond_to(:messages)
    end

    it "should should have ancestry" do
      SocialUser.roots.should be_true
    end
  end

  describe "create with method" do
    before(:each) do
      @user_template = OpenStruct.new(@attr)
    end

    it "should create record with given value" do
      expect do
        SocialUser.create_with(@user_template)
      end.to change{SocialUser.count}.by(1)
    end
  end

  describe "from_omniauth" do
    before(:each) do
      @oauth = OmniauthExamples.test_oauth
    end

    it "should create record from what's given in auth hash" do
      expect do
        SocialUser.from_omniauth(@oauth)
      end.to change{SocialUser.count}.by(3)
    end

    it "should assign parent id to subusers" do
      SocialUser.from_omniauth(@oauth)
      SocialUser.last.parent_id.should == SocialUser.first.id
    end
  end

end
