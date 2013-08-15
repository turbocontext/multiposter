# --- encoding: utf-8 ---
require "spec_helper"

describe GooglePlusStrategy do
  describe GooglePlusStrategy::User do
    let(:gp){GooglePlusStrategy::User.new({:uid => ENV['google_plus_page_id'], :email => ENV['google_plus_email'], access_token: ENV['google_plus_password']})}

    it "should get headers from login page" do
      curl = gp.get_page(gp.login_url)
      gp.get_headers(curl)["Cache-control"].should ==  "no-cache, no-store"
    end

    it "should get page title" do
      gp.get_page_name.should == "Кавигатор - Новости Дагестана"
    end

    it "should get cookies from google" do
      curl = gp.get_page(gp.login_url)
      gp.get_cookies(curl)["GALX"].to_s.should =~ /\w+/i
    end

    it "should return form action" do
      curl = gp.get_page(gp.login_url)
      soup = Nokogiri::HTML(curl.body_str)
      gp.get_form_action(soup).should == 'https://accounts.google.com/ServiceLoginAuth'
    end

    it "shoud collect form data" do
      curl = gp.get_page(gp.login_url)
      soup = Nokogiri::HTML(curl.body_str)
      gp.get_post_data(soup)['dsh'].should =~ /\d+/i
    end

    it "should get long" do
      VCR.turn_off!
      WebMock.disable!
      gp.login.should =~ /SAPISID/

      gp.get_access_token.should =~ /AObGSA/
      gp.post_wall('message from console').should == 1
    end

    it "false shoud be true" do
      false.should be_true
    end
  end
end
