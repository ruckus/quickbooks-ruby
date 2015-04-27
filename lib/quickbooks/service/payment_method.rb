module Quickbooks
  module Service
    class PaymentMethod < BaseService

      def fetch_by_name(name)
        self.query(search_name_query(name)).entries.first
      end

      def search_name_query(name)
        "SELECT * FROM PaymentMethod WHERE Name = '#{name}'"
      end

      def update(entity, options = {})
        raise Quickbooks::InvalidModelException.new('Payment Method sparse update is not supported by Intuit at this time') if options[:sparse] && options[:sparse] == true
        super(entity, options)
      end

      def delete(department)
        department.active = false
        update(department, :sparse => false)
      end

      private

      def model
        Quickbooks::Model::PaymentMethod
      end
    end
  end
end
