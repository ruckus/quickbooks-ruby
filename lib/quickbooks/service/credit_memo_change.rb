module Quickbooks
  module Service
    class CreditMemoChange < ChangeService

      private

      def entity
        "CreditMemo"
      end

      def model
        Quickbooks::Model::CreditMemoChange
      end
    end
  end
end
