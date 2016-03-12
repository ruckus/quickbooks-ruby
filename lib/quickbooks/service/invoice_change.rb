module Quickbooks
  module Service
    class InvoiceChange < ChangeService

      private

      def entity
        "Invoice"
      end

      def model
        Quickbooks::Model::InvoiceChange
      end
    end
  end
end
