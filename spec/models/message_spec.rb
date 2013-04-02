require 'spec_helper'

describe Message do
  before(:each) do
    @social_user = FactoryGirl.create(:social_user)
    @message_set = FactoryGirl.create(:message_set)
    @attr = {
      text: "message text",
      access_token: "access token",
      uid: "123",
      social_user_id: @social_user.id,
      message_set_id: @message_set.id
    }
  end
  it "should create message with valid attributes" do
    expect{Message.create(@attr)}.to change{Message.count}.by(1)
  end

  describe "relations" do
    it "should belong to social user" do
      Message.new.should respond_to(:social_user)
    end

    it "should belong to message set" do
      Message.new.should respond_to(:message_set)
    end
  end

  describe "validation" do
    it "should reject creating records without text" do
      Message.create(@attr.merge(text: nil)).should_not be_valid
    end

    it "should reject creating records without social_user_id" do
      Message.create(@attr.merge(social_user_id: nil)).should_not be_valid
    end

    # it "should reject creating records without message_set_id" do
    #   Message.create(@attr.merge(message_set_id: nil)).should_not be_valid
    # end

    # it "should reject creating records without uid" do
    #   Message.create(@attr.merge(uid: nil)).should_not be_valid
    # end

    # it "should reject creating records without access_token" do
    #   Message.create(@attr.merge(access_token: nil)).should_not be_valid
    # end
  end
end
