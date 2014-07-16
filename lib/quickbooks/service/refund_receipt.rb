module Quickbooks
  module Service
    class RefundReceipt < BaseService

      private

      def model
        Quickbooks::Model::RefundReceipt
      end
    end
  end
end
