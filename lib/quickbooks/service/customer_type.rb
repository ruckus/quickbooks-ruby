module Quickbooks
  module Service
    class CustomerType < BaseService

      def delete(customer_type)
        raise Quickbooks::UnsupportedOperation.new('Deleting CustomerType is not supported by Intuit')
      end

      def create(customer_type)
        raise Quickbooks::UnsupportedOperation.new('Creating/updating CustomerType is not supported by Intuit')
      end

      private

      def model
        Quickbooks::Model::CustomerType
      end
    end
  end
end
