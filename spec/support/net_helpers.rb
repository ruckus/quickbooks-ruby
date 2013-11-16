module NetHelpers
  def stub_request(method, url, status = ["200", "OK"], body = nil)
    if url.is_a?(String)
      url = url.gsub('?', '\?')
    end
    url_regexp = %r|#{url}|
    FakeWeb.register_uri(method, url_regexp, :status => status, :body => body)
  end
end

RSpec.configure do |config|
  config.include(NetHelpers)
end
