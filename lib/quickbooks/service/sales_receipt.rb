module Quickbooks
  module Service
    class SalesReceipt < BaseService
      include ServiceCrud

      def default_model_query
        "SELECT * FROM SALESRECEIPT"
      end

      def model
        Quickbooks::Model::SalesReceipt
      end
    end
  end
end
