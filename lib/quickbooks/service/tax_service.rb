module Quickbooks
  module Service
    class TaxService < BaseService

      private

      def model
        Quickbooks::Model::TaxService
      end
    end
  end
end
