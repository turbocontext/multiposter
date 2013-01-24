require "spec_helper"

describe User do
  it "should create user with valid attributes" do
    User.create(email: "sand@king.com", password: "sandwich").should be_true
  end

  describe "relations" do
    it "should have message set relation" do
      User.new.should respond_to(:social_users)
    end

    it "should have messages" do
      User.new.should respond_to(:message_sets)
    end

    it "should have messages" do
      User.new.should respond_to(:messages)
    end
  end
end
