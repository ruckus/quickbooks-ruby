module Quickbooks
  module Service
    class CompanyCurrency < BaseService
      
      private
      
      def model
        Quickbooks::Model::CompanyCurrency
      end
      
    end
  end
end
