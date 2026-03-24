module Quickbooks
  module Service
    class InventoryAdjustment < BaseService

      def create(inventory_adjustment, options = {})
        # pin to 70
        v = "?minorversion=#{Quickbooks.minorversion >= 70 ? Quickbooks.minorversion : 70}"
        params = { query: { minorversion: Quickbooks.minorversion >= 70 ? Quickbooks.minorversion : 70 } }
        super(inventory_adjustment, options.merge(params))
      end

      private

      def model
        Quickbooks::Model::InventoryAdjustment
      end
    end
  end
end
