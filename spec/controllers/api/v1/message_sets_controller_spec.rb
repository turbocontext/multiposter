require "spec_helper"

describe Api::V1::MessageSetsController do
  let(:attr) { {}}
  describe "POST 'create'" do
    it "should create some messages" do
      expect do
        post :create, messages: attr
      end.to change{Message.count}.by(1)
    end
  end
end
