module Quickbooks
  module Service
    class Estimate < BaseService
      include ServiceCrud

      def delete(estimate, options = {})
        delete_by_query_string(estimate)
      end

      private

      def default_model_query
        "SELECT * FROM Estimate"
      end

      def model
        Quickbooks::Model::Estimate
      end
    end
  end
end