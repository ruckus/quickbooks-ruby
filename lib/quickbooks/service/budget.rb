module Quickbooks
  module Service
    class Budget < BaseService

      private

      def model
        Quickbooks::Model::Budget
      end
    end
  end
end
