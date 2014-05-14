module Quickbooks
  module Service
    class TimeActivity < BaseService
      include ServiceCrud

      def delete(time_activity, options = {})
        delete_by_query_string(time_activity)
      end

      private

      def model
        Quickbooks::Model::TimeActivity
      end
    end
  end
end
