# --- encoding: utf-8 ---
require "spec_helper"

describe OdnoklassnikiStrategy do
  let(:od){OdnoklassnikiStrategy::User.new({:email => ENV['odnoklassniki_email'], access_token: ENV['odnoklassniki_password']})}
  describe OdnoklassnikiStrategy::User do

    let(:od_name){'Кавказский Навигатор'}
    let(:od_url){'http://www.odnoklassniki.ru/profile/529740250964'}

    # it "should login user" do
    #   page = od.login
    #   page.text.should =~ /Основное/i
    # end

    # it "should get page name" do
    #   od.user_name.should == od_name
    # end

    # it "should get profile url" do
    #   od.user_url.should == od_url
    # end

    # it "should get uid from long format" do
    #   od.get_uid(od_url).should == '529740250964'
    # end

    # it "should get uid from short format" do
    #   od.get_uid('http://www.odnoklassniki.ru/profile').should == 'profile'
    # end

    # it "should get uid from short format" do
    #   od.get_uid('http://www.odnoklassniki.ru/group/1234567890').should == '1234567890'
    # end

    # it "should return main user with key attributes" do
    #   user = od.main_user
    #   user.nickname.should == od_name
    #   user.url.should == od_url
    #   user.uid.should == '529740250964'
    # end

    # it "should return links to user's groups" do
    #   od.groups_pages.should include("http://www.odnoklassniki.ru/group/52076969984084", "http://www.odnoklassniki.ru/goodwears")
    # end

    # it "should return subusers" do
    #   subusers = od.subusers
    #   subusers.length.should == 1
    #   subusers.first.url.should == "http://www.odnoklassniki.ru/group/52076969984084"
    # end
  end

  describe OdnoklassnikiStrategy::OdnoklassnikiMessage do
    let(:message){
      OdnoklassnikiStrategy::OdnoklassnikiMessage.new(
        OpenStruct.new(
          email: ENV['odnoklassniki_email'],
          access_token: ENV['odnoklassniki_password'],
          url: 'http://www.odnoklassniki.ru/profile/529740250964')
      )
    }
    let(:attr){OpenStruct.new(text: 'long text', short_text: 'short_text', url: 'http://kavigator.ru')}
    # it "should be sent" do
    #   message.send(attr).should be_true
    # end
  end
end
