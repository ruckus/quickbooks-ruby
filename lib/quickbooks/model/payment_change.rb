module Quickbooks
  module Model
    # Refer to: https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/change_data_capture
    class PaymentChange < ChangeModel
      XML_NODE = "Payment"
    end
  end
end
