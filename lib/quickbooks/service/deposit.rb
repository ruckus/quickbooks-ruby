module Quickbooks
  module Service
    class Deposit < BaseService

      def delete(payment)
        delete_by_query_string(payment)
      end

      private

      def model
        Quickbooks::Model::Deposit
      end
    end
  end
end
