module Quickbooks
  module Model
    class CreditCardPayment < BaseModel
      xml_accessor :number, :from => 'Number'
      xml_accessor :type, :from => 'Type'
      xml_accessor :name_on_account, :from => 'NameOnAcct'
      xml_accessor :expiry_month, :from => 'CcExpiryMonth', :as => Integer
      xml_accessor :expiry_year, :from => 'CcExpiryYear', :as => Integer
      xml_accessor :bill_address, :from => 'BillAddrStreet'
      xml_accessor :postal_code, :from => 'PostalCode'
      xml_accessor :commercial_card_code, :from => 'CommercialCardCode'
      xml_accessor :txn_mode, :from => 'CCTxnMode'
      xml_accessor :txn_type, :from => 'CCTxnType'
      xml_accessor :previous_txn_id, :from => 'PrevCCTransId'
    end
  end
end
