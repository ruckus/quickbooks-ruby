module Quickbooks
  module Service
    class BillPayment < BaseService

      def default_model_query
        "SELECT * FROM BillPayment"
      end

      def model
        Quickbooks::Model::BillPayment
      end
    end
  end
end
