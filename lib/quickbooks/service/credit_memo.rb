module Quickbooks
  module Service
    class CreditMemo < BaseService

      def default_model_query
        "SELECT * FROM CreditMemo"
      end

      def model
        Quickbooks::Model::CreditMemo
      end
    end
  end
end
