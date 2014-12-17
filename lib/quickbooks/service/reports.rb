module Quickbooks
  module Service
    class Reports < BaseService

      private
      
      def model
        Quickbooks::Model::Reports
      end
    end
  end
end