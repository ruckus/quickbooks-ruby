module Quickbooks
  module Service
    class TaxRate < BaseService

      private

      def model
        Quickbooks::Model::TaxRate
      end
    end
  end
end
