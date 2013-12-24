module Quickbooks
  module Service
    class Payment < BaseService
      include ServiceCrud
      
      def delete(payment, options={})
        delete_by_query_string(payment)
      end
      
      private
      
      def default_model_query
        "SELECT * FROM PAYMENT"
      end
      
      def model
        Quickbooks::Model::Payment
      end
    end
  end
end