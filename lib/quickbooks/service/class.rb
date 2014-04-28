module Quickbooks
  module Service
    class Class < BaseService

      def update(entity, options = {})
        raise Quickbooks::InvalidModelException.new('Class sparse update is not supported by Intuit at this time') if options[:sparse] && options[:sparse] == true
        super(entity, options)
      end

      def delete(classs)
        classs.active = false
        update(classs, :sparse => false)
      end

      private

      def model
        Quickbooks::Model::Class
      end

    end
  end
end
