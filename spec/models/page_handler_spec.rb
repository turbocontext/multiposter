require "spec_helper"
require "nokogiri"

describe PageHandler do
  it "should get google page" do
    VCR.use_cassette 'get_google_page' do
      curl = PageHandler.get_page('http://www.google.ru/?gws_rd=cr')
      Nokogiri::HTML(curl.body_str).at_css('title').text.should == "Google"
    end
  end

  it "should post data there" do
    VCR.use_cassette 'post_google_page' do
      curl = PageHandler.get_page('http://www.google.ru/?gws_rd=cr', nil, {q: "Sandwich"})
      Nokogiri::HTML(curl.body_str).at_css('title').text.should =~ /method not allowed/i
    end
  end

  it "should get some cookies to cookie monster" do
    VCR.use_cassette 'get_google_page' do
      curl = PageHandler.get_page('http://www.google.ru/?gws_rd=cr')
      PageHandler.get_cookies(curl).should =~ /NID=/
    end
  end

end
