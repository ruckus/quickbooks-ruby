module NetHelpers

  # +strict+ indicates whether we want to use a regex for a matching URL, which is needed
  # for URLs that use query params. If you don't need use query params
  # than its suggested to use strict = true
  def stub_request(method, url, status = ["200", "OK"], body = nil, headers = {}, strict = true)
    if !strict
      if url.is_a?(String)
        url = url.gsub('?', '\?')
      end
      uri = %r|#{url}|
    else
      uri = url
    end
    FakeWeb.register_uri(method, uri, { :status => status, :body => body }.merge(headers))
  end
end

RSpec.configure do |config|
  config.include(NetHelpers)
end
