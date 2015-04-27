module Quickbooks
  module Model
    class PurchaseTaxRateList < BaseModel
      XML_COLLECTION_NODE = "PurchaseTaxRateList"
      XML_NODE = "PurchaseTaxRateList"
      REST_RESOURCE = "purchasetaxratelist"

      xml_accessor :tax_rate_detail, :from => "TaxRateDetail", :as => [TaxRateDetail]
    end
  end
end
