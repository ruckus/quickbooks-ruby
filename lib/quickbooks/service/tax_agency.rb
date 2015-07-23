module Quickbooks
  module Service
    class TaxAgency < BaseService

      private

      def model
        Quickbooks::Model::TaxAgency
      end
    end
  end
end
