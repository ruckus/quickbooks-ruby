module Quickbooks
  module Service
    class JournalEntry < BaseService

      private

      def model
        Quickbooks::Model::JournalEntry
      end
    end
  end
end
