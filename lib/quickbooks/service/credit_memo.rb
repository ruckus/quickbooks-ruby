module Quickbooks
  module Service
    class CreditMemo < BaseService

      def model
        Quickbooks::Model::CreditMemo
      end
    end
  end
end
