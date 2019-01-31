module Quickbooks
  module Service
    class Customer < BaseService

      def delete(customer)
        customer.active = false
        update(customer, :sparse => true)
      end

      def url_for_resource(resource)
        url = super(resource)
        "#{url}?minorversion=#{Quickbooks::Model::Customer::MINORVERSION}"
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/customer/#{id}?minorversion=#{Quickbooks::Model::Customer::MINORVERSION}"
        fetch_object(model, url, params)
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        url = super(query, start_position, max_results, options)
        "#{url}&minorversion=#{Quickbooks::Model::Customer::MINORVERSION}"
      end

      private

      def model
        Quickbooks::Model::Customer
      end

    end
  end
end
