# --- encoding: utf-8 ---
# page.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
require "nokogiri"
require "page_handler"
require "capybara/poltergeist"

module OdnoklassnikiStrategy
  class User
    include Capybara::DSL

    attr_reader :auth, :email, :password

    def initialize(authorization)
      @auth = authorization
      @email = auth[:email]
      @password = auth[:access_token]
    end

    def main_user
      return OpenStruct.new({
        provider: 'odnoklassniki',
        uid: user_uid,
        url: user_url,
        email: auth[:email],
        nickname: user_name,
        access_token: auth[:access_token]
      })
    end

    def user_url
      # login.find('.mctc_navMenuSec[hrefattrs="st.cmd=userMain&st._aid=NavMenu_User_Main"]').click
      @user_url ||= login.current_url
    end

    def user_name
      @user_name ||= login.find('.mctc_nameLink.bl').text
    end

    def user_uid
      @user_uid ||= get_uid(user_url)
    end

    def get_uid(url)
      long_regex = /http:\/\/www\.odnoklassniki\.ru\/profile\/(\d*)\z/
      short_regex = /http:\/\/www\.odnoklassniki\.ru\/(\w*)\z/
      (url.match(long_regex) || url.match(short_regex))[1]
    end

    def subusers
      lg = login
      groups_pages(lg).inject([]) do |res, link|
        lg.visit(link)
        # lg.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
        if lg.has_selector?('#posting_form_text_field_labeled')
          res << OpenStruct.new({
            provider: 'odnoklassniki',
            uid: get_uid(page_url(lg)),
            url: page_url(lg),
            email: auth[:email],
            nickname: page_name(lg),
            access_token: auth[:access_token]
          })
        end
        res
      end
    end

    def page_url(lg)
      lg.current_url
    end

    def page_name(lg)
      lg.find('.mctc_name_holder.textWrap').text
    end

    def groups_pages(lg)
      groups_link = page.find('.mctc_navMenuSec[hrefattrs="st.cmd=userAltGroup&st._aid=NavMenu_User_AltGroups"]')
      page.visit("http://www.odnoklassniki.ru#{groups_link['href']}")
      groups = page.all('#listBlockPanelUserGroupsListBlock .cardsList .cardsList_li a').inject([]) do |res, el|
        res << "http://www.odnoklassniki.ru#{el['href']}"
      end
    end

    def login
      if @login
        if @login.has_selector?('.mctc_navMenuSec.mctc_navMenuActiveSec[hrefattrs="st\.cmd\=userMain&st\.\_aid\=NavMenu_User_Main"]')
          puts "no real login, main page"
          return @login
        else
          puts "no real login, going to main page"
          @login.find('.mctc_navMenuSec[hrefattrs="st.cmd=userMain&st._aid=NavMenu_User_Main"]').click
        end
      else
        puts "real login"
        @login = initialize_session
        @login.visit "http://www.odnoklassniki.ru"
        @login.fill_in 'Логин', with: email
        @login.fill_in 'Пароль', with: password
        @login.click_on 'Войти'
        @login.click_on 'Основное'
        @login
      end
    end

    def initialize_session(driver = :poltergeist)
      if driver == :poltergeist || driver == 'poltergeist'
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, js_errors: false)
        end
      end
      Capybara.current_driver = driver
      Capybara.javascript_driver = driver
      Capybara::Session.new(driver)
    end
  end

  class OdnoklassnikiMessage
    attr_accessor :user, :post_page, :post_url
    def initialize(user)
      @user = user
    end

    def send(message)
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
  end
end
