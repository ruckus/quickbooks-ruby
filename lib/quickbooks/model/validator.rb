module Quickbooks
  module Model
    module Validator

      def line_item_size
        validates_length_of :line_items, :minimum => 1, :message => 'At least 1 line item is required'
      end
    end
  end
end
