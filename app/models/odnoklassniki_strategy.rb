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
        uid: @auth[:uid],
        url: get_user_url,
        email: @auth[:email],
        nickname: get_user_name,
        access_token: @auth[:access_token]
      })
    end

    def get_user_url
      page = login
      page.click_on get_user_name
      page.current_url
    end

    def get_user_name
      page = login
      page.find('.mctc_nameLink.bl').text
    end

    def subusers
      # page = login
      # click_on "Группы"
      # page.find('#listBlockPanelUserGroupsListBlock .cardsList .cardsList_li a').each do |el|
      #   click_on el
      # end
      []
    end

    def login
      # return @login if @login
      # return page if page.text =~ /Основное/i
      # visit "http://www.odnoklassniki.ru"
      # fill_in 'Логин', with: auth[:email]
      # fill_in 'Пароль', with: auth[:access_token]
      # click_on 'Войти'
      # @login = page
      s = Capybara::Session.new(OdnoklassnikiStrategy::JAVASCRIPT_DRIVER)
      s.visit "http://www.odnoklassniki.ru"
      s.fill_in 'Логин', with: auth[:email]
      s.fill_in 'Пароль', with: auth[:access_token]
      s.click_on 'Войти'
      s
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
