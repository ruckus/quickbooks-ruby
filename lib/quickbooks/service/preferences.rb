module Quickbooks
  module Service
    class Preferences < BaseService

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        url = super(query, start_position, max_results, options)
        "#{url}&minorversion=#{Quickbooks::Model::Preferences::MINORVERSION}"
      end

      private

      def model
        Quickbooks::Model::Preferences
      end
    end
  end
end
