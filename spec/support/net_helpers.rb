module NetHelpers
  def stub_http_request(method, url, status = ["200", "OK"], body = nil, headers = {}, strict = true)
    unless url.index('minorversion')
      if url.index('?')
        url = "#{url}&minorversion=#{Quickbooks.minorversion}"
      else
        url = "#{url}?minorversion=#{Quickbooks.minorversion}"
      end
    end
    #puts "URL: #{url}"
    stub_request(method, url).to_return(body: body, status: status)
  end
end

RSpec.configure do |config|
  config.include(NetHelpers)
end
