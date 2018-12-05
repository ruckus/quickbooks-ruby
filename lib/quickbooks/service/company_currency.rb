module Quickbooks
  module Service
    class CompanyCurrency < BaseService

      def delete(company_currency)
        company_currency.active = false
        update(company_currency, :sparse => true)
      end

      private

      def model
        Quickbooks::Model::CompanyCurrency
      end

    end
  end
end
