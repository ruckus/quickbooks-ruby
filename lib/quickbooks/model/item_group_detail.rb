module Quickbooks
  module Model
    class ItemGroupDetail < BaseModel
      include HasLineItems

      xml_accessor :line_items, :from => 'ItemGroupLine', :as => [ItemGroupLine]
    end
  end
end