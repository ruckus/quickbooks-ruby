module Quickbooks
  module Service
    class TaxCode < BaseService

      private

      def model
        Quickbooks::Model::TaxCode
      end
    end
  end
end
