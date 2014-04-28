module Quickbooks
  module Service
    class Term < BaseService

      def delete(term)
        term.active = false
        update(term, :sparse => true)
      end

      private

      def model
        Quickbooks::Model::Term
      end
    end
  end
end
