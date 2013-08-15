# --- encoding: utf-8 ---
require "curb"
require "nokogiri"

module GooglePlusStrategy
  class User
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

    def get_page(url, cookies = nil, post_data = nil)
      curl = Curl::Easy.new(url) do |http|
        http.headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'
        http.headers['Cookie'] = cookies unless cookies.nil?
      end

      if post_data
        curl.post_body = post_data.to_query
        curl.http_post
      else
        curl.perform
      end
      curl
    end

    def get_headers(curl)
      http_response, *http_headers = curl.header_str.split(/[\r\n]+/).map(&:strip)
      http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]
    end

    def get_cookies(curl)
      http_response, *http_headers = curl.header_str.split(/[\r\n]+/).map(&:strip)
      cookie_strings = http_headers.select{|el| el =~ /Set-Cookie:/}
      res = cookie_strings.inject('') do |result, string|
        s = string.scan(/Set-Cookie: (.*?);/).flatten.first
        result += "#{s}; "
      end
      res[0..-3]
    end

    def login
      curl = get_page(login_url)
      cookies = get_cookies(curl)
      soup = Nokogiri::HTML(curl.body_str)
      form_action = get_form_action(soup)
      post_data = get_post_data(soup).merge('Email' => auth[:email], 'Passwd' => auth[:access_token])
      new_curl = get_page(form_action, cookies, post_data)
      @cookies = get_cookies(new_curl)
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

    def get_post_data(soup)
      soup.css('input').inject({}) do |result, input|
        result.merge(input.attr('name') => input.attr('value'))
      end
    end

    def get_form_action(soup)
      soup.css('form').first.attr('action')
    end
  end
end
