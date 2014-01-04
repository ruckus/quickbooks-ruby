module Quickbooks
  module Model
    class BillPaymentCheck < BaseModel
      xml_accessor :bank_account_ref, :from => 'BankAccountRef', :as => BaseReference
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :check_detail, :from => 'CheckDetail', :as => CheckPayment
      xml_accessor :payee_address, :from => 'PayeeAddr', :as => PhysicalAddress

      reference_setters :bank_account_ref
    end
  end
end