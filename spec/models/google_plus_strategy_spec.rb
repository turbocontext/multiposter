# --- encoding: utf-8 ---
require "spec_helper"
require "page_handler"

describe GooglePlusStrategy do
  describe GooglePlusStrategy::User do
    let(:gp){GooglePlusStrategy::User.new({:uid => ENV['google_plus_page_id'], :email => ENV['google_plus_email'], access_token: ENV['google_plus_password']})}

    it "should return main user" do
      VCR.use_cassette 'kavigator_page' do
        user = gp.main_user
        user.nickname.should == "Кавигатор - Новости Дагестана"
        user.email.should == ENV['google_plus_email']
        user.uid.should == ENV['google_plus_page_id']
        user.access_token.should == ENV['google_plus_password']
      end
    end

    it "should get page title" do
      VCR.use_cassette 'kavigator_page' do
        gp.get_page_name.should == "Кавигатор - Новости Дагестана"
      end
    end

    it "should return empty array of subusers for now" do
      gp.subusers.should == []
    end

    it "should collect form data" do
      VCR.use_cassette 'google_login_page' do
        curl = PageHandler.get_page(gp.login_url)
        soup = Nokogiri::HTML(curl.body_str)
        gp.get_login_form_data(soup)['dsh'].should =~ /\d+/i
      end
    end

    it "should login user and return some cookiez" do
      VCR.use_cassette 'google_log_in' do
        gp.login.should =~ /SAPISID/
      end
    end

    # it "should get long" do
    #   VCR.turn_off!
    #   WebMock.disable!
    #   gp.login.should =~ /SAPISID/

    #   gp.get_access_token.should =~ /AObGSA/
    #   gp.post_wall('message from console').should == 1
    # end

    it "false shoud be true" do
      false.should be_true
    end
  end
end
