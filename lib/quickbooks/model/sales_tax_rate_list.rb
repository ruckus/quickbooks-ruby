module Quickbooks
  module Model
    class SalesTaxRateList < BaseModel
      XML_COLLECTION_NODE = "SalesTaxRateList"
      XML_NODE = "SalesTaxRateList"
      REST_RESOURCE = "salestaxratelist"

      xml_accessor :tax_rate_detail, :from => "TaxRateDetail", :as => [TaxRateDetail]
    end
  end
end
