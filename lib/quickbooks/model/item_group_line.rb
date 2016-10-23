module Quickbooks
  module Model
    class ItemGroupLine < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => BaseReference
      xml_accessor :quantity, :from => 'Qty'

      def id
        item_ref.value.to_i
      end

      def name
        item_ref.name
      end

      def type
        item_ref.type
      end
    end
  end
end
