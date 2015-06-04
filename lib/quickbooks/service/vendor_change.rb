module Quickbooks
  module Service
    class VendorChange < ChangeService

      private

      def entity
        "Vendor"
      end

      def model
        Quickbooks::Model::VendorChange
      end
    end
  end
end
