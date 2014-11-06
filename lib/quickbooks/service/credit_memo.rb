module Quickbooks
  module Service
    class CreditMemo < BaseService

      def delete(credit_memo)
        delete_by_query_string(credit_memo)
      end

      private

      def model
        Quickbooks::Model::CreditMemo
      end
    end
  end
end
