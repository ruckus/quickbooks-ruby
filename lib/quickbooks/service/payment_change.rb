module Quickbooks
  module Service
    class PaymentChange < ChangeService

      private

      def entity
        "Payment"
      end

      def model
        Quickbooks::Model::PaymentChange
      end
    end
  end
end
