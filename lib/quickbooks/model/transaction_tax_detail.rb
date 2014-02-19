module Quickbooks
  module Model
    class TransactionTaxDetail < BaseModel

      xml_accessor :txn_tax_code_ref, :from => 'TxnTaxCodeRef', :as => BaseReference
      xml_accessor :total_tax, :from => 'TotalTax', :as => BigDecimal, :to_xml => :to_f.to_proc
      xml_accessor :lines, :from => 'TaxLine', :as => [TaxLine]

    end
  end
end
