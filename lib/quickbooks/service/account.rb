module Quickbooks
  module Service
    class Account < BaseService

      def delete(account)
        account.active = false
        update(account, :sparse => true)
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        url = super(query, start_position, max_results, options)
        "#{url}&minorversion=#{Quickbooks::Model::Account::MINORVERSION}"
      end

      private

      def model
        Quickbooks::Model::Account
      end
    end
  end
end
