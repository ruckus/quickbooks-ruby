module Quickbooks
  module Model
    class BillPaymentCheck < BaseModel
      xml_accessor :bank_account_ref, :from => 'BankAccountRef', :as => Model::BaseReference
      xml_accessor :print_status, :from => 'PrintStatus'
      xml_accessor :check_detail, :from => 'CheckDetail', :as => Model::CheckPayment
      xml_accessor :payee_address, :from => 'PayeeAddr', :as => Model::PhysicalAddress
    end
  end
end