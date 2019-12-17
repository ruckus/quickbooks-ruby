module Quickbooks
  module Model
    class ChangeDataCapture < BaseModel

      attr_accessor :xml

      TYPES = ["Bill", "BillPayment", "CreditMemo", "Deposit", "Invoice", "JournalEntry", "Payment",
        "Purchase", "RefundReceipt", "SalesReceipt", "PurchaseOrder", "VendorCredit", "Transfer",
        "Estimate", "Account", "Budget", "Class", "Customer", "Department", "Employee", "Item",
        "PaymentMethod", "Term", "Vendor"]

      def all_types
         data = {}
         TYPES.each do |entity|
           if xml.css(entity).first != nil
             data[entity] = all_of_type(entity)
           end
         end
         data
      end

      private

      def all_of_type(entity)
        parse_block(xml.css(entity).first.parent, entity)
      end

      def parse_block(node, entity)
        model = "Quickbooks::Model::#{entity}".constantize
        models = []
        all_items = node.css(entity).map do |item|
          if item.attribute("status").try(:value) == "Deleted"
            Quickbooks::Model::ChangeModel.from_xml(item)
          else
            model.from_xml(item)
          end
        end
      end

    end
  end
end