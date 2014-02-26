module Quickbooks
  module Service
    class TaxRate < BaseService

      private

      def default_model_query
        "SELECT * FROM TaxRate"
      end

      def model
        Quickbooks::Model::TaxRate
      end
    end
  end
end
