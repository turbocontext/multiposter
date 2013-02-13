require 'spec_helper'

describe UserMessage do
  describe "associations" do
    it "should respond to messages call" do
      UserMessage.new.should respond_to(:message)
    end

    it "should belong to user" do
      UserMessage.new.should respond_to(:user)
    end
  end
end
