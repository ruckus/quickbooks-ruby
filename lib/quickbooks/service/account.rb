module Quickbooks
  module Service
    class Account < BaseService
      include ServiceCrud

      def delete(account)
        account.active = false
        update(account, :sparse => true)
      end

      private

      def default_model_query
        "SELECT * FROM ACCOUNT"
      end

      def model
        Quickbooks::Model::Account
      end
    end
  end
end
