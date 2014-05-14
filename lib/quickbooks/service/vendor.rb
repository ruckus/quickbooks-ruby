module Quickbooks
  module Service
    class Vendor < BaseService

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

      def model
        Quickbooks::Model::Vendor
      end

    end
  end
end
