# --- encoding: utf-8 ---
require "curb"
require "nokogiri"

module GooglePlusStrategy
  class User
    extend PageHandler
    attr_accessor :auth, :info, :login_url, :logout_url, :post_page, :post_url
    def initialize(auth)
      @auth = auth

      @login_url = 'https://accounts.google.com/ServiceLogin'
      @logout_url = 'https://www.google.com/m/logout'
      @post_page = "https://plus.google.com/b/#{auth[:uid]}/#{auth[:uid]}/posts"
      @post_url = "https://plus.google.com/b/#{auth[:uid]}/_/sharebox/post"
    end

    def main_user
      page_name = get_page_name
      return OpenStruct.new({
        provider: 'google_plus',
        uid: @auth[:uid],
        url: "https://plus.google.com/u/0/#{auth[:uid]}/posts",
        email: @auth[:email],
        nickname: page_name,
        access_token: @auth[:access_token]
      })
    end

    def subusers
      []
    end

    def get_page_name
      page_url = "https://plus.google.com/#{auth[:uid]}/posts"
      Nokogiri::HTML(Curl.get(page_url).body_str).at_css('title').text.scan(/(.*) – Google+/).first.first
    end

    def get_login_form_data(soup)
      soup.css('input').inject({}) do |result, input|
        result.merge(input.attr('name') => input.attr('value'))
      end
    end

    def login
      curl = PageHandler.get_page(login_url)
      cookies = PageHandler.get_cookies(curl)
      puts cookies
      soup = Nokogiri::HTML(curl.body_str)
      form_action = soup.css('form').first.attr('action')
      post_data = get_login_form_data(soup).merge('Email' => auth[:email], 'Passwd' => auth[:access_token])
      new_curl = PageHandler.get_page(form_action, cookies, post_data)
      puts new_curl.header_str
      @cookies = PageHandler.get_cookies(new_curl)
    end

    def get_access_token
      curl = get_page(post_page, @cookies)
      @access_token = curl.body_str.scan(/\"(AObGSA.*?)\"/).first.first
    end

    def post_wall(text)
      post_data = {
        'at' => @access_token,
        'f.req' => '["' + text + '","oz:'+auth[:uid]+'.'+(Time.now.to_i.to_s)+'.0",null,null,null,null,"[]",null,null,true,[],false,null,null,[],null,false,null,null,null,null,null,null,null,null,null,null,false,false,false,null,null,null,null,null,null,[],[[[null,null,1]],null]]'
      }
      curl = get_page(post_url + "/?spam=20&_reqid="+(Time.now.to_i % 1000000).to_s + "&rt=j", @cookies, post_data)
    end

  end
end
