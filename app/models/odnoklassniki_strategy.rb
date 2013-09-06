# --- encoding: utf-8 ---
require "nokogiri"
require "page_handler"
require "capybara/poltergeist"

module OdnoklassnikiStrategy
  class User
    include Capybara::DSL

    attr_accessor :auth, :info

    def initialize(auth)
      Capybara.current_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
      @auth = auth
    end

    def main_user
      return OpenStruct.new({
        provider: 'odnoklassniki',
        uid: @auth[:uid],
        url: get_user_url,
        email: @auth[:email],
        nickname: get_user_name,
        access_token: @auth[:access_token]
      })
    end

    def get_user_url
      page = login
      click_on get_user_name
      current_url
    end

    def get_user_name
      page = login
      page.find('.mctc_nameLink.bl').text
    end

    def subusers
      []
    end

    def login
      return @login if @login
      return page if page.text =~ /Основное/i
      visit "http://www.odnoklassniki.ru"
      fill_in 'Логин', with: auth[:email]
      fill_in 'Пароль', with: auth[:access_token]
      click_on 'Войти'
      @login = page
    end
  end

  class GooglePlusMessage
    attr_accessor :user, :post_page, :post_url
    def initialize(user)
      @user = user
      @post_page = "https://plus.google.com/b/#{user[:uid]}/#{user[:uid]}/posts"
      @post_url = "https://plus.google.com/b/#{user[:uid]}/_/sharebox/post"
    end

    def login_cookies
      @login_cookies ||= GooglePlusStrategy::User.new(user).login
    end

    def send(message)
      text = text_from(message)
      post_data = {
        'at' => access_token,
        'f.req' => '["' + text + '","oz:'+user.uid+'.'+(Time.now.to_i.to_s)+'.0",null,null,null,null,"[]",null,null,true,[],false,null,null,[],null,false,null,null,null,null,null,null,null,null,null,null,false,false,false,null,null,null,null,null,null,[],[[[null,null,1]],null]]'
      }
      curl = PageHandler.get_page(post_url + "/?spam=20&_reqid="+(Time.now.to_i % 1000000).to_s + "&rt=j", login_cookies, post_data)
    end

    def text_from(message)
      if message.text.blank?
        message.short_text + "\\n" + (message.url || '')
      else
        message.text + "\\n" + (message.url || '')
      end
    end

    def delete(message)
      true
    end

    def access_token
      curl = PageHandler.get_page(post_page, login_cookies)
      curl.body.scan(/\"(AObGSA.*?)\"/).first.first
    end
  end
end
