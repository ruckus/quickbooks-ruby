module Quickbooks
  module Service
    class Employee < BaseService
      include ServiceCrud

      # override update as sparse is not supported
      def update(entity, options = {})
        raise InvalidModelException.new('Employee sparse update is not supported by Intuit at this time') if options[:sparse] && options[:sparse] == true
        super(entity, options)
      end

      def delete(employee)
        employee.active = false
        update(employee, :sparse => false)
      end

      private

      def default_model_query
        "SELECT * FROM EMPLOYEE"
      end

      def model
        Quickbooks::Model::Employee
      end

    end
  end
end
