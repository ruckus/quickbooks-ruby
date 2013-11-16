module Quickbooks
  module Model
    class LinkedTransaction < BaseModel
      xml_accessor :txn_id, :from => 'TxnId'
      xml_accessor :txn_type, :from => 'TxnType'
      xml_accessor :txn_line_id, :from => 'TxnLineId'
    end
  end
end