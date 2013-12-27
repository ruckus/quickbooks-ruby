module Quickbooks
  module Model
    class CheckPayment < BaseModel
      xml_accessor :check_number, :from => 'CheckNum'
      xml_accessor :status, :from => 'Status'
      xml_accessor :name_on_account, :from => 'NameOnAcct'
      xml_accessor :account_number, :from => 'AcctNum'
      xml_accessor :bank_name, :from => 'BankName'
    end
  end
end