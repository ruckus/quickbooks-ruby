module Quickbooks
  module Service
    class Term < BaseService
      include ServiceCrud

      def delete(term)
        term.active = false
        update(term, :sparse => true)
      end

      private

      def default_model_query
        "SELECT * FROM Term"
      end

      def model
        Quickbooks::Model::Term
      end
    end
  end
end
