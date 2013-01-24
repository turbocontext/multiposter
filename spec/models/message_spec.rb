require 'spec_helper'

describe Message do

  it "should create a message with valid attributes" do
    Message.create(text: "sand", message_set_id: 1, social_user_id: 1).should be_true
  end

  describe "constraints" do
    it "should reject messages without set" do
      Message.new(text: "sand", social_user_id: 1).should_not be_valid
    end

    it "should be invalid without text" do
      Message.new(social_user_id: 1, message_set_id: 1).should_not be_valid
    end

    it "should be invalid without social user id" do
      Message.new(text: "sand", message_set_id: 1).should_not be_valid
    end
  end

  describe "relations" do
    it "should belong to message set" do
      Message.new.should respond_to(:message_set)
    end

    it "should respond to user call" do
      Message.new.should respond_to(:social_user)
    end
  end
end
