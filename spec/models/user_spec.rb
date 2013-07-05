require 'spec_helper'

describe User do
  describe "relations" do
    it "should have many message sets" do
      User.new.should respond_to(:message_sets)
    end

    it "should have many social usres" do
      User.new.should respond_to(:social_users)
    end

    it "should have many messages through social users" do
      User.new.should respond_to(:messages)
    end
  end

  describe "methods" do
    it "should return users from given network" do
      user = FactoryGirl.create(:user)
      social_user = FactoryGirl.create(:social_user, provider: "test_provider", user_id: user.id)
      user.social(:test_provider).should include(social_user)
      user.social(:test_provider).count.should == 1
    end

    it "should create user's api key right after registration" do
      user = User.create(email: "mail@example.org", password: "password")
      user.api_key.length.should eq(32)
    end
  end
end
