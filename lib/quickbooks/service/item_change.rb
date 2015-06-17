module Quickbooks
  module Service
    class ItemChange < ChangeService

      private

      def entity
        "Item"
      end

      def model
        Quickbooks::Model::ItemChange
      end
    end
  end
end
