module Quickbooks
  module Service
    class Transfer < BaseService

      def delete(transfer)
        delete_by_query_string(transfer)
      end

      private

      def model
        Quickbooks::Model::Transfer
      end
    end
  end
end