module Quickbooks
  module Model
    class WebSiteAddress < BaseModel
      xml_accessor :uri, :from => 'URI'

      def initialize(uri = nil)
        self.uri = uri if uri
      end

      def to_xml(options = {})
        return "" if uri.to_s.empty?
        super(options)
      end
    end
  end
end
