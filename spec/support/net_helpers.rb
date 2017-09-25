require 'cgi'
require 'uri'
require 'addressable/template'

module NetHelpers

  # +strict+ indicates whether we want to use a regex for a matching URL, which is needed
  # for URLs that use query params. If you don't need use query params
  # than its suggested to use strict = true
  def stub_http_request(method, url, status = [200, "OK"], body = nil, strict = true)
    # URLs thta look like
    # https://quickbooks.api.intuit.com/v3/company/9991111222/query?query=SELECT+*+FROM+Account+STARTPOSITION+1+MAXRESULTS+20
    # cause the Ruby regex engine to issue this warning:
    # warning: nested repeat operator '+' and '*' was replaced with '*' in regular expression
    # Which causes the underlying URL to be modified and thusly a different URL gets registered with FakeWeb
    # Do the modification ourselves so we can predict the URL
    # url = url.gsub('+*+', '+%2A+')

    # unless strict
    #   if url.is_a?(String)
    #     url = url.gsub('?', '\?')
    #   end
    #   uri = %r|#{url}|
    # else
    #   uri = url
    # end
    # puts "REGISTER: method=#{method}, uri=#{uri}"
    # #FakeWeb.register_uri(method, uri, status: status, body: body)

    # stub_request(method, uri).to_return(body: body, status: status)

    # if strict
    #   stub_request(method, url).to_return(body: body, status: status)
    # else
    #   uri = URI.parse(url)
    #   template = template = Addressable::Template.new("#{uri.scheme}://#{uri.host}#{uri.path}{?query*}")
    #   stub_request(method, template).to_return(body: body, status: status)
    # end

    stub_request(method, url).to_return(body: body, status: status)
  end

end

RSpec.configure do |config|
  config.include(NetHelpers)
end
