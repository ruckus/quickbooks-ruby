module Quickbooks
  module Service
    class CompanyInfo < BaseService

      private
      
      def model
        Quickbooks::Model::CompanyInfo
      end
    end
  end
end
