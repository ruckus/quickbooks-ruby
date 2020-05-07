module Quickbooks
  module Service
    class Customer < BaseService

      def delete(customer)
        customer.active = false
        update(customer, :sparse => true)
      end

      def url_for_resource(resource)
        url = super(resource)
        url
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/customer/#{id}"
        fetch_object(model, url, params)
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        super(query, start_position, max_results, options)
      end

      private

      def model
        Quickbooks::Model::Customer
      end

    end
  end
end
