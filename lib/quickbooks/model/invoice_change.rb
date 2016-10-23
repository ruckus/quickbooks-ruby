module Quickbooks
  module Model
    # Refer to:
    # - https://developer.intuit.com/docs/0100_quickbooks_online/0200_dev_guides/accounting/change_data_capture
    class InvoiceChange < ChangeModel
      XML_NODE = "Invoice"
    end
  end
end
