require "spec_helper"

describe MessagesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  describe "GET 'index'" do
    before(:each) do
      @suser = FactoryGirl.create(:social_user, user_id: @user.id)
      @mes1 = FactoryGirl.create(:message, social_user_id: @suser.id)
      @mes2 = FactoryGirl.create(:message, social_user_id: @suser.id)
      @user2 = FactoryGirl.create(:user)
      @suser2 = FactoryGirl.create(:social_user, user_id: @user2.id)
      @mes3 = FactoryGirl.create(:message, social_user_id: @suser2.id)
    end

    it "should fetch all messages from current user" do
      get :index
      assigns(:messages).should include(@mes1, @mes2)
      assigns(:messages).should_not include(@mes3)
    end
  end
end
