module Quickbooks
  module Service
    class Bill < BaseService
      include ServiceCrud

      def default_model_query
        "SELECT * FROM Bill"
      end

      def model
        Quickbooks::Model::Bill
      end
    end
  end
end
