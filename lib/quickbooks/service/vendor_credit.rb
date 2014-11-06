module Quickbooks
  module Service
    class VendorCredit < BaseService

      def delete(vendor_credit)
        delete_by_query_string(vendor_credit)
      end

      private
      
      def model
        Quickbooks::Model::VendorCredit
      end
    end
  end
end
