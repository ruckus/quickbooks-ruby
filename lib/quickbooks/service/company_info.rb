module Quickbooks
  module Service
    class CompanyInfo < BaseService

      private

      def default_model_query
        "SELECT * FROM CompanyInfo"
      end

      def model
        Quickbooks::Model::CompanyInfo
      end
    end
  end
end
