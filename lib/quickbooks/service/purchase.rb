module Quickbooks
  module Service
    class Purchase < BaseService

      def default_model_query
        "SELECT * FROM Purchase"
      end

      def model
        Quickbooks::Model::Purchase
      end
    end
  end
end
