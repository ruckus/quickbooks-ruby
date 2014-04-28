module Quickbooks
  module Service
    class Purchase < BaseService


      def model
        Quickbooks::Model::Purchase
      end
    end
  end
end
