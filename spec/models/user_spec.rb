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
    it "should return users from given network"
  end
end
