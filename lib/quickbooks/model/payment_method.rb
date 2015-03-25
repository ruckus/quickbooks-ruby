module Quickbooks
  module Model
    class PaymentMethod < BaseModel
      REST_RESOURCE = 'paymentmethod'
      XML_COLLECTION_NODE = "PaymentMethod"
      XML_NODE = "PaymentMethod"
      include NameEntity::PermitAlterations

      CREDIT_CARD = "CREDIT_CARD"
      NON_CREDIT_CARD = "NON_CREDIT_CARD"

      PAYMENT_METHOD_TYPES = [CREDIT_CARD, NON_CREDIT_CARD]

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :type, :from => 'Type'
      xml_accessor :active?, :from => 'Active'
      xml_accessor :amount, :from => 'Amount', :as => BigDecimal, :to_xml => to_xml_big_decimal

      validates_inclusion_of :type, :in => PAYMENT_METHOD_TYPES, :allow_nil => true
    end
  end
end
