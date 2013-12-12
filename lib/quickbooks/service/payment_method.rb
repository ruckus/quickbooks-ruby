module Quickbooks
  module Service
    class PaymentMethod < BaseService
      include ServiceCrud

      def default_model_query
        "SELECT * FROM PaymentMethod"
      end

      def fetch_by_name(name)
        self.query(search_name_query(name)).entries.first
      end

      def model
        Quickbooks::Model::PaymentMethod
      end

      def search_name_query(name)
        "SELECT * FROM PaymentMethod WHERE Name = '#{name}'"
      end
    end
  end
end
