module Quickbooks
  module Service
    class BillPayment < BaseService

      private

      def model
        Quickbooks::Model::BillPayment
      end
    end
  end
end
