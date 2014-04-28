module Quickbooks
  module Service
    class Estimate < BaseService

      def delete(estimate, options = {})
        delete_by_query_string(estimate)
      end

      private

      def model
        Quickbooks::Model::Estimate
      end
    end
  end
end
