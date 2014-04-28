module Quickbooks
  module Service
    class VendorCredit < BaseService

      private
      
      def model
        Quickbooks::Model::VendorCredit
      end
    end
  end
end
