module Quickbooks
  module Service
    class Customer < BaseService
      include ServiceCrud

      def delete(customer)
        customer.active = false
        update(customer, :sparse => true)
      end

      private

      def default_model_query
        "SELECT * FROM CUSTOMER"
      end

      def model
        Quickbooks::Model::Customer
      end

    end
  end
end
