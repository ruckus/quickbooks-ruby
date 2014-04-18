require 'roxml'
require 'logger'
require 'nokogiri'
require 'active_model'
require 'cgi'
require 'uri'
require 'date'
require 'forwardable'
require 'oauth'
require 'quickbooks/util/logging'
require 'quickbooks/util/http_encoding_helper'
require 'quickbooks/util/name_entity'
require 'quickbooks/util/query_builder'

#== Models
require 'quickbooks/model/base_model'
require 'quickbooks/model/base_reference'
require 'quickbooks/model/access_token_response'
require 'quickbooks/model/meta_data'
require 'quickbooks/model/class'
require 'quickbooks/model/custom_field'
require 'quickbooks/model/sales_item_line_detail'
require 'quickbooks/model/sub_total_line_detail'
require 'quickbooks/model/department'
require 'quickbooks/model/discount_line_detail'
require 'quickbooks/model/discount_override'
require 'quickbooks/model/payment_line_detail'
require 'quickbooks/model/account_based_expense_line_detail'
require 'quickbooks/model/linked_transaction'
require 'quickbooks/model/line'
require 'quickbooks/model/item'
require 'quickbooks/model/account'
require 'quickbooks/model/check_payment'
require 'quickbooks/model/credit_card_payment'
require 'quickbooks/model/telephone_number'
require 'quickbooks/model/other_contact_info'
require 'quickbooks/model/email_address'
require 'quickbooks/model/web_site_address'
require 'quickbooks/model/physical_address'
require 'quickbooks/model/invoice_line_item'
require 'quickbooks/model/company_info'
require 'quickbooks/model/customer'
require 'quickbooks/model/sales_receipt'
require 'quickbooks/model/payment'
require 'quickbooks/model/payment_method'
require 'quickbooks/model/credit_memo'
require 'quickbooks/model/bill_line_item'
require 'quickbooks/model/bill'
require 'quickbooks/model/bill_payment_line_item'
require 'quickbooks/model/bill_payment_check'
require 'quickbooks/model/bill_payment_credit_card'
require 'quickbooks/model/bill_payment'
require 'quickbooks/model/vendor'
require 'quickbooks/model/employee'
require 'quickbooks/model/term'
require 'quickbooks/model/markup_info'
require 'quickbooks/model/group_line_detail'
require 'quickbooks/model/item_based_expense_line_detail'
require 'quickbooks/model/tax_line_detail'
require 'quickbooks/model/tax_line'
require 'quickbooks/model/time_activity'
require 'quickbooks/model/transaction_tax_detail'
require 'quickbooks/model/purchase_line_item'
require 'quickbooks/model/purchase'
require 'quickbooks/model/purchase_order'
require 'quickbooks/model/vendor_credit'
require 'quickbooks/model/estimate'
require 'quickbooks/model/invoice'
require 'quickbooks/model/tax_rate'
require 'quickbooks/model/tax_rate_detail'
require 'quickbooks/model/sales_tax_rate_list'
require 'quickbooks/model/tax_code'
require 'quickbooks/model/fault'
require 'quickbooks/model/batch_request'
require 'quickbooks/model/batch_response'

#== Services
require 'quickbooks/service/service_crud'
require 'quickbooks/service/base_service'
require 'quickbooks/service/access_token'
require 'quickbooks/service/class'
require 'quickbooks/service/company_info'
require 'quickbooks/service/customer'
require 'quickbooks/service/department'
require 'quickbooks/service/invoice'
require 'quickbooks/service/item'
require 'quickbooks/service/sales_receipt'
require 'quickbooks/service/account'
require 'quickbooks/service/payment_method'
require 'quickbooks/service/credit_memo'
require 'quickbooks/service/bill'
require 'quickbooks/service/bill_payment'
require 'quickbooks/service/vendor'
require 'quickbooks/service/employee'
require 'quickbooks/service/payment'
require 'quickbooks/service/term'
require 'quickbooks/service/time_activity'
require 'quickbooks/service/purchase'
require 'quickbooks/service/purchase_order'
require 'quickbooks/service/vendor_credit'
require 'quickbooks/service/estimate'
require 'quickbooks/service/tax_rate'
require 'quickbooks/service/tax_code'
require 'quickbooks/service/batch'

module Quickbooks
  @@logger = nil

  class << self
    def logger
      @@logger ||= ::Logger.new($stdout) # TODO: replace with a real log file
    end

    def logger=(logger)
      @@logger = logger
    end

    # set logging on or off
    attr_writer :log, :log_xml_pretty_print

    # Returns whether to log. Defaults to 'false'.
    def log?
      @log ||= false
    end

    # pretty printing the xml in the logs is "on" by default
    def log_xml_pretty_print?
      defined?(@log_xml_pretty_print) ? @log_xml_pretty_print : true
    end

    def log(msg)
      if log?
        logger.info(msg)
        logger.flush if logger.respond_to?(:flush)
      end
    end
  end # << self

  class InvalidModelException < StandardError; end

  class AuthorizationFailure < StandardError; end

  class ServiceUnavailable < StandardError; end

  class IntuitRequestException < StandardError
    attr_accessor :message, :code, :detail, :type, :request_xml
    def initialize(msg)
      self.message = msg
      super(msg)
    end
  end


  class Collection
    attr_accessor :entries

    # Legacy Attributes (v2)
    attr_accessor :count, :current_page

    # v3 Attributes
    attr_accessor :start_position, :max_results, :total_count
  end

end
