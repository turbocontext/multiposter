class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :set_locale
  protect_from_forgery

  def set_locale
    I18n.locale = get_locale()
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

  # private
    def get_locale
      if current_user && available_languages.include?(current_user.language)
        current_user.language
      elsif accept_lang = request.env['HTTP_ACCEPT_LANGUAGE']
        lang = accept_lang.scan(/^[a-z]{2}/).first
        lang if available_languages.include?(lang)
      else
        params[:locale] || :ru
      end
    end

    def available_languages
      ['ru', 'en']
    end
end
