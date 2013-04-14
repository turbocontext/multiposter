module ApplicationHelper

  def shortcut_for(net, href=nil, name = nil)
    name ||= net.to_s.capitalize
    link = href || "/auth/#{net}"
    raw %Q{<a class="shortcut" href="#{link}">
          <span class="icon">
            <i class="icon-#{net}"></i>
          </span>
          <span class="label">
            #{name}
          </span>
        <span class="badge">#{current_user.social(net).count}</span>
      </a>
      }
  end

  def html_button_to(name, options = {}, html_options = {}, button_html = nil)
    html_options = html_options.stringify_keys
    convert_boolean_attributes!(html_options, %w( disabled ))

    method_tag = ''
    if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
      method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
    end

    form_method = method.to_s == 'get' ? 'get' : 'post'

    request_token_tag = ''
    if form_method == 'post' && protect_against_forgery?
      request_token_tag = tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => form_authenticity_token)
    end

    if confirm = html_options.delete("confirm")
      html_options["onclick"] = "return #{confirm_javascript_function(confirm)};"
    end

    url = options.is_a?(String) ? options : self.url_for(options)
    name ||= url

    html_options.merge!("type" => "submit", "value" => name)
    name = button_html || url
    "<form method=\"#{form_method}\" action=\"#{escape_once url}\" class=\"button-to\">" +
      method_tag + content_tag("button", name, html_options) + request_token_tag + "</form>"
  end
end
