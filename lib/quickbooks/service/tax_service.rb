module Quickbooks
  module Service
    class TaxService < BaseServiceJSON
      private

      def model
        Quickbooks::Model::TaxService
      end
    end
  end
end
