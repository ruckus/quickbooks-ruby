module Quickbooks
  module Model
    class TaxLine < BaseModel

      xml_accessor :id, :from => 'Id'
      xml_accessor :line_num, :from => 'LineNum', :as => Integer
      xml_accessor :description, :from => 'Description'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => Proc.new { |val| val.to_f }
      xml_accessor :detail_type, :from => 'DetailType'

      xml_accessor :tax_line_detail, :from => 'TaxLineDetail', :as => TaxLineDetail

    end
  end
end
