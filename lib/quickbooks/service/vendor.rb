module Quickbooks
  module Service
    class Vendor < BaseService
      include ServiceCrud

      # override update as sparse is not supported
      def update(entity, options = {})
        raise InvalidModelException.new('Vendor sparse update is not supported by Intuit at this time') if options[:sparse] && options[:sparse] == true
        super(entity, options)
      end

      def delete(vendor)
        vendor.active = false
        update(vendor, :sparse => false)
      end

      private

      def default_model_query
        "SELECT * FROM VENDOR"
      end

      def model
        Quickbooks::Model::Vendor
      end

    end
  end
end
