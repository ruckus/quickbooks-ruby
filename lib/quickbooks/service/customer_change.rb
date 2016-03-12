module Quickbooks
  module Service
    class CustomerChange < ChangeService

      private

      def entity
        "Customer"
      end

      def model
        Quickbooks::Model::CustomerChange
      end
    end
  end
end
