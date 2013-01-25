require "spec_helper"

describe SocialUser do
  before(:each) do
    @attr = {
      uid: "ddd",
      provider: "snd",
      access_token: "secret",
      secret_token: "secrete",
      user_id: "12",
      email: "email@email.com"
    }
  end
  it "should create new social user with valid attributes" do
    SocialUser.create(@attr).should be_true
  end

  describe "validations" do
    it "should reject records without provider" do
      SocialUser.new(@attr.merge(provider: nil)).should_not be_valid
    end

    it "should reject records without access token" do
      SocialUser.new(@attr.merge(access_token: nil)).should_not be_valid
    end
  end

  describe "relations" do
    it "should have many message sets and messages through it" do
      SocialUser.new.should respond_to(:message_sets)
      SocialUser.new.should respond_to(:messages)
    end
  end

end

describe UserInfo do
  before(:each) do
    @oauth1 = {
      provider: 'facebook',
      uid: '100003700047553',
      info: {
        nickname: 'offical.kavigator',
        name: 'Offical Kavigator',
        email: 'kavigator@gmail.com',
        first_name: 'Offical',
        last_name: 'Kavigator',
        image: 'http://graph.facebook.com/100003700047553/picture?type=square',
        urls: {
          "Facebook" => 'http://www.facebook.com/offical.kavigator'
        },
        location: 'Makhachkala',
        verified: true
      },
      credentials: {
        token: 'The secret token',
        expires_at: '1364215148',
        expires: true
      },
      extra: {
        raw_info: {
          id: '100003700047553',
          name: 'Offical Kavigator',
          first_name: 'Offical',
          last_name: 'Kavigator',
          link: 'http://www.facebook.com/offical.kavigator',
          username: 'offical.kavigator',
          location:{
            id: '108527135837627',
            name: 'Makhachkala'
          },
          gender: 'male',
          email: 'kavigator@gmail.com',
          timezone: '4',
          locale: 'en_US',
          verified: true,
          updated_time: '2013-01-15T12:11:25+0000'
        }
      }
    }
    @oauth2 = {
      provider: 'twitter',
      uid: '100003700047553',
      info: {
        nickname: 'offical.kavigator',
        name: 'Offical Kavigator',
        first_name: 'Offical',
        last_name: 'Kavigator',
        image: 'http://graph.facebook.com/100003700047553/picture?type=square',
        urls: {
          "Facebook" => 'http://www.facebook.com/offical.kavigator'
        },
        location: 'Makhachkala',
        verified: true
      },
      credentials: {
        token: 'The secret token',
        expires_at: '1364215148',
        expires: true
      },
      extra: {
        raw_info: {
          id: '100003700047553',
          name: 'Offical Kavigator',
          first_name: 'Offical',
          last_name: 'Kavigator',
          link: 'http://www.facebook.com/offical.kavigator',
          username: 'offical.kavigator',
          location:{
            id: '108527135837627',
            name: 'Makhachkala'
          },
          gender: 'male',
          email: 'kavigator@gmail.com',
          timezone: '4',
          locale: 'en_US',
          verified: true,
          updated_time: '2013-01-15T12:11:25+0000'
        }
      }
    }
  end
  it "should extract user info from omniauth hash" do
    user_info = UserInfo.new(@oauth1)
    user_info.email.should == @oauth1[:info][:email]
    user_info = UserInfo.new(@oauth2)
    user_info.email.should == "offical.kavigator@twitter.com"
  end
end
