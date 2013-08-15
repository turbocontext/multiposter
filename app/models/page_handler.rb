module PageHandler
  def self.get_page(url, cookies = nil, post_data = nil)
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

  def self.get_cookies(curl)
    http_response, *http_headers = curl.header_str.split(/[\r\n]+/).map(&:strip)
    cookie_strings = http_headers.select{|el| el =~ /Set-Cookie:/}
    res = cookie_strings.inject('') do |result, string|
      s = string.scan(/Set-Cookie: (.*?);/).flatten.first
      result += "#{s}; "
    end
    res[0..-3]
  end
end
