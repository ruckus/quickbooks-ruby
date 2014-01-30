module Quickbooks
  module Model
    class GroupLineDetail < BaseModel
      xml_accessor :group_item_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :quantity, :from => 'Quantity', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :line_items, :from => 'Line', :as => [Line]

      reference_setters :group_item_ref
    end
  end
end