# --- encoding: utf-8 ---
require "spec_helper"

describe OdnoklassnikiStrategy do
  describe OdnoklassnikiStrategy::User do

    let(:od){OdnoklassnikiStrategy::User.new({:email => ENV['odnoklassniki_email'], access_token: ENV['odnoklassniki_password']})}
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

    it "should return main user with key attributes" do
      user = od.main_user
      user.nickname.should == od_name
      user.url.should == od_url
      user.uid.should == '529740250964'
    end

    # it "should return links to user's groups" do
    #   od.groups_pages(od.login).should == ["http://www.odnoklassniki.ru/group/52076969984084", "http://www.odnoklassniki.ru/goodwears"]
    # end

    # it "should return subusers" do
    #   subusers = od.subusers
    #   subusers.length.should == 1
    #   subusers.first.url.should == "http://www.odnoklassniki.ru/group/52076969984084"
    # end

    it "should be false" do
      true.should be_falsy
    end
  end
end
