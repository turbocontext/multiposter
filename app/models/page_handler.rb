require "curb"
module PageHandler
  def self.get_page(url, cookies = nil, post_data = nil)
    HTTPI.log = false
    request = HTTPI::Request.new(url)
    request.headers['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'
    request.headers['Cookie'] = cookies unless cookies.nil?

    method = post_data.nil? ? :get : :post
    request.body = post_data if post_data
    HTTPI.request(method, request, :curb)
  end

  def self.make_cookie_string(request)
    if request.headers["Set-Cookie"].class == String
      extract_cookie(request.headers["Set-Cookie"])
    else
      request.headers["Set-Cookie"].inject('') do |result, cookie|
        result += extract_cookie(cookie) + '; '
      end[0..-3]
    end

    # request.cookies.inject('') do |result, cookie|
    #   result += cookie.name_and_value + "; "
    # end[0..-3]
  end

  def self.extract_cookie(set_cookie_value)
    c = CGI::Cookie.parse(set_cookie_value)
    c.inject('') do |result, el|
      result += el[0].to_s + "=" + el[1].first.to_s + "; " unless ["path", "expires", "domain"].include?(el[0].to_s.downcase)
      result
    end[0..-3]
  end
end
