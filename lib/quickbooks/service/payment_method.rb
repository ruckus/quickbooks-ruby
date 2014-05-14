module Quickbooks
  module Service
    class PaymentMethod < BaseService

      def fetch_by_name(name)
        self.query(search_name_query(name)).entries.first
      end

      def search_name_query(name)
        "SELECT * FROM PaymentMethod WHERE Name = '#{name}'"
      end

      private

      def model
        Quickbooks::Model::PaymentMethod
      end
    end
  end
end
