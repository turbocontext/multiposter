require 'spec_helper'

describe MessageSet do
  describe "associations" do
    it "should respond to messages call" do
      MessageSet.new.should respond_to(:messages)
    end

    it "should belong to user" do
      MessageSet.new.should respond_to(:user)
    end
  end
end
