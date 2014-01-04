module Quickbooks
  module Model
    class BillPaymentCreditCard < BaseModel
      xml_accessor :cc_account_ref, :from => 'CCAccountRef', :as => Model::BaseReference
      xml_accessor :cc_detail, :from => 'CCDetail', :as => Model::CreditCardPayment
    end
  end
end