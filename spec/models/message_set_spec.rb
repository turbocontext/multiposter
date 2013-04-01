require 'spec_helper'

describe MessageSet do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = {user_id: @user.id}
  end
  it "should create record with valid attributes" do
    expect{MessageSet.create(@attr)}.to change{MessageSet.count}.by(1)
  end

  describe "validations" do
    it "should deny empty user_id column" do
      MessageSet.new(@attr.merge(user_id: nil)).should_not be_valid
    end
  end

  describe "relation" do
    it "should respond to user method" do
      MessageSet.new.should respond_to(:user)
    end

    it "should respond to messages method" do
      MessageSet.new.should respond_to(:messages)
    end
  end
end
