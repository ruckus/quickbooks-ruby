module Quickbooks
  module Service
    class Purchase < BaseService

      private

      def model
        Quickbooks::Model::Purchase
      end
    end
  end
end
