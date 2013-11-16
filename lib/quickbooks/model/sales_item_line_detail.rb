module Quickbooks
  module Model
    class SalesItemLineDetail < BaseModel
      xml_accessor :item_ref, :from => 'ItemRef', :as => Quickbooks::Model::InvoiceItemRef
      xml_accessor :class_ref, :from => 'ClassRef'
      xml_accessor :unit_price, :from => 'UnitPrice', :as => Float
      xml_accessor :quantity, :from => 'Qty', :as => Float
      xml_accessor :tax_code_ref, :from => 'TaxCodeRef'
    end
  end
end

=begin
				<DetailType>SalesItemLineDetail</DetailType>
				<SalesItemLineDetail>
					<ItemRef name="Sales">1</ItemRef>
					<UnitPrice>50</UnitPrice>
					<Qty>1</Qty>
					<TaxCodeRef>NON</TaxCodeRef>
				</SalesItemLineDetail>
=end