module Quickbooks
  module Model
    class TaxService < BaseModel
      XML_COLLECTION_NODE = "TaxService"
      XML_NODE = "TaxService"
      REST_RESOURCE = "taxservice/taxcode"

      xml_accessor :tax_code_id, :from => "TaxCodeId"
      xml_accessor :tax_code, :from => "TaxCode"
      xml_accessor :tax_rate_details, :from => 'TaxRateDetails', :as => [TaxRateDetailLine]

      validates_presence_of :tax_code

    end
  end
end
