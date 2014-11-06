module Quickbooks
  module Service
    class TimeActivity < BaseService

      def delete(time_activity)
        delete_by_query_string(time_activity)
      end

      private

      def model
        Quickbooks::Model::TimeActivity
      end
    end
  end
end
