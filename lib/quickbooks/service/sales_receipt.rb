module Quickbooks
  module Service
    class SalesReceipt < BaseService

      private

      def model
        Quickbooks::Model::SalesReceipt
      end
    end
  end
end
