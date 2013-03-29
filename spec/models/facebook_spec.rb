require "support/omniauth_examples"
require "spec_helper"

describe Facebook do
  describe User do
    it "should create user info hash" do
      user = Facebook::User.new(OmniauthExamples.facebook_oauth)
      user.main_user.should be_true
    end
  end
end
