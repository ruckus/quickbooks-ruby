module Quickbooks
  module Service
    class Invoice < BaseService

      def list(query, options = {})
        #query = "SELECT * FROM INVOICE"
        options[:page] ||= 1
        options[:per_page] ||= 20
        fetch_collection(query, Quickbooks::Model::Invoice, options)
      end

    end
  end
end