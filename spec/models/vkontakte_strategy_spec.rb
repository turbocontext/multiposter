require 'spec_helper'

describe VkontakteStrategy do
  before(:each) do
    @params = 'https://oauth.vk.com/blank.html#access_token=bc128c11f4bab78f9a0f1ba84b0a2d6dee58b6bb30545d8c413c549896223f8e40c24d72f9ce5e3dd9604&expires_in=0&user_id=190495550'
  end

  it "should fetch params from the url string" do
    VCR.use_cassette 'vkontakte_test' do
      user = VkontakteStrategy.parse_info(@params)
      user.uid.should == '190495550'
      user.provider.should == 'vkontakte'
      user.nickname.should == 'Kavigator Dagestan-News'
    end
  end
end
