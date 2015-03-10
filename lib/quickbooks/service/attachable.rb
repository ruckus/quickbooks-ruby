module Quickbooks
  module Service
    class Attachable < BaseService

      private

      def model
        Quickbooks::Model::Attachable
      end
    end
  end
end
