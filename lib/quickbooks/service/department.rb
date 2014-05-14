module Quickbooks
  module Service
    class Department < BaseService

      def update(entity, options = {})
        raise Quickbooks::InvalidModelException.new('Department sparse update is not supported by Intuit at this time') if options[:sparse] && options[:sparse] == true
        super(entity, options)
      end

      def delete(department)
        department.active = false
        update(department, :sparse => false)
      end

      private

      def model
        Quickbooks::Model::Department
      end

    end
  end
end
