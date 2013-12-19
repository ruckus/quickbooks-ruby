module Quickbooks
  module Service
    class CreditMemo < BaseService
      include ServiceCrud

      def default_model_query
        "SELECT * FROM CreditMemo"
      end

      def model
        Quickbooks::Model::CreditMemo
      end
    end
  end
end
