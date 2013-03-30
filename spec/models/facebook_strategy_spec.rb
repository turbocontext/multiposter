require "support/omniauth_examples"
require "spec_helper"

describe FacebookStrategy do
  describe User do
    before(:each) do
      @user = FacebookStrategy::User.new(OmniauthExamples.facebook_oauth)
    end

    it "should create user info hash" do
      main_user = @user.main_user
      main_user.nickname.should == 'official.kavigator'
    end

    it "should fetch all pages and user page info hash"
  end
end
