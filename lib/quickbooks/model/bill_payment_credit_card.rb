module Quickbooks
  module Model
    class BillPaymentCreditCard < BaseModel
      xml_accessor :cc_account_ref, :from => 'CCAccountRef', :as => BaseReference
      xml_accessor :cc_detail, :from => 'CCDetail', :as => CreditCardPayment

      reference_setters
    end
  end
end
