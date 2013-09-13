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
      user_struct(auth[:email], auth[:access_token], get_uid(user_url), user_url, user_name)
    end

    def subusers
      lg = login
      groups_pages.inject([]) do |res, link|
        lg.visit(link)
        if lg.has_selector?('#posting_form_text_field_labeled')
          res << user_struct(auth[:email], auth[:access_token], get_uid(page_url(lg)), page_url(lg), page_name(lg))
        end
        res
      end
    end

    def user_url
      @user_url ||= login.current_url
    end

    def user_name
      @user_name ||= login.find('.mctc_nameLink.bl').text
    end

    def get_uid(url)
      long_regex = /http:\/\/www\.odnoklassniki\.ru\/profile\/(\d*)\z/
      short_regex = /http:\/\/www\.odnoklassniki\.ru\/(\w*)\z/
      group_regex = /http:\/\/www\.odnoklassniki\.ru\/group\/(\d*)\z/
      (url.match(long_regex) || url.match(short_regex) || url.match(group_regex))[1]
    end

    def page_url(lg)
      lg.current_url
    end

    def page_name(lg)
      lg.find('.mctc_name_holder.textWrap').text
    end

    def groups_pages
      lg = login
      groups_link = lg.find('.mctc_navMenuSec[hrefattrs="st.cmd=userAltGroup&st._aid=NavMenu_User_AltGroups"]')
      lg.visit("http://www.odnoklassniki.ru#{groups_link['href']}")
      groups = lg.all('#listBlockPanelUserGroupsListBlock .cardsList .cardsList_li a').inject([]) do |res, el|
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
          visit "http://www.odnoklassniki.ru"
          @login.find('.mctc_navMenuSec[hrefattrs="st.cmd=userMain&st._aid=NavMenu_User_Main"]').click
          @login
        end
      else
        puts "real login"
        @login = OdnoklassnikiStrategy.login(email, password)
      end
    end

    def user_struct(email, token, uid, url, nickname)
      OpenStruct.new({
        provider: 'odnoklassniki',
        uid: uid,
        url: url,
        email: email,
        nickname: nickname,
        access_token: token
      })
    end

  end

  class OdnoklassnikiMessage
    attr_accessor :user, :login
    def initialize(user)
      @user = user
    end

    def send(message)
      login = OdnoklassnikiStrategy.login(user.email, user.access_token)
      login.visit(user.url)
      login.find('#posting_form_text_field_labeled').click
      login.fill_in('any_text_here', with: text_from(message))
      login.find('#opentext').click
      login.fill_in('1.posting_form_text_field', with: message.url)
      sleep 3
      login.find('.button-pro.form-actions_a.form-actions__yes').click
      # login.click_on 'Поделиться'
    end

    def text_from(message)
      message.text.blank? ? message.short_text : message.text
    end

    def delete(message)
      true
    end
  end


  def self.initialize_session(driver = :poltergeist)
    if driver == :poltergeist || driver == 'poltergeist'
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, js_errors: false)
      end
    end
    Capybara.current_driver = driver
    Capybara.javascript_driver = driver
    Capybara::Session.new(driver)
  end

  def self.login(email, password)
    login = initialize_session
    login = OdnoklassnikiStrategy.initialize_session
    login.visit "http://www.odnoklassniki.ru"
    login.fill_in 'st.email', with: email
    login.fill_in 'st.password', with: password
    login.click_on 'hook_FormButton_button_go'
    sleep 3
    login.find('.mctc_navMenuSec.mctc_navMenuActiveSec[hrefattrs="st.cmd=userMain&st._aid=NavMenu_User_Main"]').click
    login.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")

    # login.click_on 'Основное'
    login
  end
end
