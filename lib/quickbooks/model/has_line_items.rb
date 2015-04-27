module Quickbooks
  module Model
    module HasLineItems
      def initialize(*args)
        ensure_line_items_initialization
        super
      end

      def ensure_line_items_initialization
        self.line_items ||= []
      end
    end
  end
end
