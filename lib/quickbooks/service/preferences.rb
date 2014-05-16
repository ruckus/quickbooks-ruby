module Quickbooks
  module Service
    class Preferences < BaseService

      private
      
      def model
        Quickbooks::Model::Preferences
      end
    end
  end
end
