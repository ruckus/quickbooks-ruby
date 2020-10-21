module Quickbooks
  module Service
    class Customer < BaseService

      def delete(customer)
        customer.active = false
        update(customer, :sparse => true)
      end

      private

      def model
        Quickbooks::Model::Customer
      end

    end
  end
end
