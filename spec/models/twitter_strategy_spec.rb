require "support/omniauth_examples"
require "spec_helper"

describe TwitterStrategy do
  describe Message do
    let(:message) { TwitterStrategy::TwitterMessage.new(FactoryGirl.create(:social_user)) }

    it "should take long text if short text is nil or zero length" do
      mess = OpenStruct.new(short_text: '', text: 'long')
      message.text_from(mess).should == 'long'
      mess = OpenStruct.new(short_text: nil, text: 'long')
      message.text_from(mess).should == 'long'
    end

    it "should take short text if there is one" do
      mess = OpenStruct.new(text: 'long', short_text: 'short')
      message.text_from(mess).should == 'short'
    end

    it "should cut text to 140 symbols if there is no link" do
      mess = OpenStruct.new(text: 'long', short_text: 's' * 141)
      message.text_from(mess).should == 's' * 140
      mess = OpenStruct.new(short_text: '', text: 'l' * 141)
      message.text_from(mess).should == 'l' * 140
    end

    it "should preserve place for link" do
      mess = OpenStruct.new(text: 'long', short_text: 's' * 141, url: 'link')
      message.text_from(mess).should == 's' * 136
    end
  end
end
