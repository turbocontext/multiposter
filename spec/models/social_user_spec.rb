require 'spec_helper'
require 'ostruct'
require 'support/omniauth_examples'
require 'test_provider_strategy'

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
    it "should should have ancestry" do
      SocialUser.roots.should be_true
    end

    it "should respond to messages query" do
      SocialUser.new.should respond_to(:messages)
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

    it "should return array with records" do
      users = SocialUser.from_omniauth(@oauth)
      users.class.should == Array
      users.each do |user|
        user.class.should == SocialUser
      end
    end
  end

  describe "clone with" do
    it "should clone one record from another" do
      user = SocialUser.create(@attr)
      user1 = SocialUser.create(@attr.merge(parent_id: user.id))
      user2 = SocialUser.create(@attr.merge(access_token: "new token", secret_token: "new secret", parent_id: nil))
      user1.clone_from(user2)
      user1.reload
      user1.access_token.should eq("new token")
      user1.secret_token.should eq("new secret")
      user1.parent_id.should == user.id
    end

    it "should assign all children records to new parent" do
      user1 = SocialUser.create(@attr)
      user2 = SocialUser.create(@attr)
      user3 = SocialUser.create(@attr.merge(parent_id: user2.id))
      user1.clone_from(user2)
      user1.reload
      user3.reload
      user3.parent_id.should == user1.id
    end
  end

end
