module Quickbooks
  module Service
    class CreditMemo < BaseService

      private
      
      def model
        Quickbooks::Model::CreditMemo
      end
    end
  end
end
