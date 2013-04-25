require 'spec_helper'

describe MessagesController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @message_set = FactoryGirl.create(:message_set, user: @user)
      @message = FactoryGirl.create(:message, message_set: @message_set)
    end

    it "should destroy message" do
      expect {delete :destroy, id: @message.id}.to change {Message.count}.by(-1)
    end

    it "should redirect to root path if there is no http refferer" do
      delete :destroy, id: @message.id
      request.should redirect_to(root_path)
    end

    it "should redirect back if there is http refferer" do
      request.env["HTTP_REFERER"] = message_sets_path
      delete :destroy, id: @message.id
      request.should redirect_to(message_sets_path)
    end
  end
end
