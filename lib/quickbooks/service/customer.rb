module Quickbooks
  module Service
    class Customer < BaseService

      def delete(customer)
        customer.active = false
        update(customer, :sparse => true)
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/customer/#{id}"
        fetch_object(model, url, params)
      end

      private

      def model
        Quickbooks::Model::Customer
      end

    end
  end
end
