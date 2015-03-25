module Quickbooks
  module Model
    class Payment < BaseModel
      include HasLineItems

      XML_COLLECTION_NODE = "Payment"
      XML_NODE = "Payment"
      REST_RESOURCE = 'payment'

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :txn_date, :from => 'TxnDate', :as => Date
      xml_accessor :private_note, :from => 'PrivateNote'
      xml_accessor :txn_status, :from => 'TxnStatus'
      xml_accessor :line_items, :from => 'Line', :as => [Line]
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :ar_account_ref, :from => 'ARAccountRef', :as => BaseReference
      xml_accessor :deposit_to_account_ref, :from => 'DepositToAccountRef', :as => BaseReference
      xml_accessor :payment_method_ref, :from => 'PaymentMethodRef', :as => BaseReference
      xml_accessor :payment_ref_number, :from => 'PaymentRefNum'
      xml_accessor :credit_card_payment, :from => 'CreditCardPayment', :as => CreditCardPayment
      xml_accessor :total, :from => 'TotalAmt', :as => BigDecimal, :to_xml => :to_f.to_proc
      xml_accessor :unapplied_amount, :from => 'UnappliedAmt', :as => BigDecimal, :to_xml => to_xml_big_decimal
      xml_accessor :process_payment, :from => 'ProcessPayment'
      xml_accessor :currency_ref, :from => 'CurrencyRef', :as => BaseReference
      xml_accessor :exchange_rate, :from => 'ExchangeRate', :as => BigDecimal, :to_xml => to_xml_big_decimal

      reference_setters :customer_ref, :ar_account_ref
      reference_setters :payment_method_ref, :deposit_to_account_ref, :currency_ref

      validate :existence_of_customer_ref

      private

      def existence_of_customer_ref
        if customer_ref.nil? || (customer_ref && customer_ref.value == 0)
          errors.add(:customer_ref, "CustomerRef is required and must be a non-zero value.")
        end
      end
    end
  end
end
