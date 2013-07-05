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

    it "should fetch all pages and user page info hash" do
      VCR.use_cassette 'facebook_test' do
        @app = FbGraph::Application.new(ENV['facebook_id'], :secret => ENV['facebook_secret'])
        user = @app.test_user!(:installed => true, :permissions => :read_stream)
        FbGraph::User.stub(:me).and_return(user)
        @user.subusers.class.should == Array
      end
    end
  end

  describe Message do
    let(:message) { FacebookStrategy::FacebookMessage.new(FactoryGirl.create(:social_user)) }

    it "should take short text if text is nil or zero length" do
      mess = OpenStruct.new(text: '', short_text: 'short')
      message.text_from(mess).should == 'short'
      mess = OpenStruct.new(text: nil, short_text: 'short')
      message.text_from(mess).should == 'short'
    end

    it "should take long text if there is one" do
      mess = OpenStruct.new(text: 'long', short_text: 'short')
      message.text_from(mess).should == 'long'
    end
  end
end
