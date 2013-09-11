# --- encoding: utf-8 ---
require "nokogiri"
require "page_handler"
require "capybara/poltergeist"

module OdnoklassnikiStrategy
  JAVASCRIPT_DRIVER = :poltergeist
  class User
    include Capybara::DSL

    attr_accessor :auth, :info

    def initialize(auth)
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, js_errors: false)
      end
      Capybara.current_driver = OdnoklassnikiStrategy::JAVASCRIPT_DRIVER
      Capybara.javascript_driver = OdnoklassnikiStrategy::JAVASCRIPT_DRIVER
      @auth = auth
    end

    def main_user
      return OpenStruct.new({
        provider: 'odnoklassniki',
        uid: @auth['email'],
        url: get_user_url,
        email: @auth['email'],
        nickname: get_user_name,
        access_token: @auth['access_token']
      })
    end

    def get_user_url
      page = login
      page.find('.mctc_navMenuSec[hrefattrs="st.cmd=userMain&st._aid=NavMenu_User_Main"]').click
      page.current_url
    end

    def goto_profile_page
      visit "http://www.odnoklassniki.com"
    end

    def get_user_name
      page = login
      # page.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
      page.find('.mctc_nameLink.bl').text
    end

    def subusers
      lg = login
      groups_pages(lg).inject([]) do |res, link|
        lg.visit(link)
        # lg.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
        if lg.has_selector?('#posting_form_text_field_labeled')
          res << OpenStruct.new({
            provider: 'odnoklassniki',
            uid: 'odnoklassniki_uid',
            url: lg.current_url,
            email: auth['email'],
            nickname: lg.find('.mctc_name_holder.textWrap').text,
            access_token: auth['access_token']
          })
        end
        res
      end
    end

    def groups_pages(lg = nil)
      lg ||= login
      groups_link = lg.find('.mctc_navMenuSec[hrefattrs="st.cmd=userAltGroup&st._aid=NavMenu_User_AltGroups"]')
      lg.visit("http://www.odnoklassniki.ru#{groups_link['href']}")
      groups = lg.all('#listBlockPanelUserGroupsListBlock .cardsList .cardsList_li a').inject([]) do |res, el|
        res << "http://www.odnoklassniki.ru#{el['href']}"
      end
    end

    def login
      return @login if @login && @login.has_selector?('.mctc_navMenuSec.mctc_navMenuActiveSec[hrefattrs="st\.cmd\=userMain&st\.\_aid\=NavMenu_User_Main"]')
      @login = Capybara::Session.new(OdnoklassnikiStrategy::JAVASCRIPT_DRIVER)
      @login.visit "http://www.odnoklassniki.ru"
      @login.fill_in 'Логин', with: auth['email']
      @login.fill_in 'Пароль', with: auth['access_token']
      @login.click_on 'Войти'
      @login
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
