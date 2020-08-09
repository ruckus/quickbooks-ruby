module Quickbooks
  module Service
    class Account < BaseService

      def delete(account)
        account.active = false
        update(account, :sparse => true)
      end

      private

      def model
        Quickbooks::Model::Account
      end
    end
  end
end
