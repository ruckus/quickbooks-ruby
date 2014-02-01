module Quickbooks
  module Service
    class VendorCredit < BaseService
      include ServiceCrud

      def default_model_query
        "SELECT * FROM VendorCredit"
      end

      def model
        Quickbooks::Model::VendorCredit
      end
    end
  end
end
