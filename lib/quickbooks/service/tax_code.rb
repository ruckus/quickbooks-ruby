module Quickbooks
  module Service
    class TaxCode < BaseService

      private

      def default_model_query
        "SELECT * FROM TaxCode"
      end

      def model
        Quickbooks::Model::TaxCode
      end
    end
  end
end
