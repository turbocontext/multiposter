require 'spec_helper'

describe VkontakteStrategy do
  before(:each) do
    @auth_string = 'https://oauth.vk.com/blank.html#access_token=bc128c11f4bab78f9a0f1ba84b0a2d6dee58b6bb30545d8c413c549896223f8e40c24d72f9ce5e3dd9604&expires_in=0&user_id=190495550'
  end

  it "should fetch params from the url string" do
    VCR.use_cassette 'vkontakte_test' do
      user = VkontakteStrategy::User.new({provider: 'vkontakte', auth_string: @auth_string})
      info = user.send(:parse_auth_string)
      info.uid.should == '190495550'
      info.provider.should == 'vkontakte'
      info.nickname.should == 'Kavigator Dagestan-News'
    end
  end
end
