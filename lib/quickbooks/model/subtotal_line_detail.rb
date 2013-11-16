module Quickbooks
  module Model
    class SubtotalLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => Quickbooks::Model::InvoiceItemRef
      xml_accessor :class_ref, :from => 'ClassRef'
      xml_accessor :unit_price, :from => 'UnitPrice', :as => Float
      xml_accessor :quantity, :from => 'Qty', :as => Float
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef'
    end
  end
end