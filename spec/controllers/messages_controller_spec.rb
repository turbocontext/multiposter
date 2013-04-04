require "spec_helper"

describe MessagesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  describe "GET 'index'" do
    before(:each) do
      @message_set1 = FactoryGirl.create(:message_set, user_id: @user.id)
      @user2 = FactoryGirl.create(:user)
      @message_set2 = FactoryGirl.create(:message_set, user_id: @user2.id)
    end

    it "should fetch all messages from current user" do
      get :index
      assigns(:message_sets).should include(@message_set1)
      assigns(:message_sets).should_not include(@message_set2)
    end
  end
end
