require 'roxml'
require 'logger'
require 'nokogiri'
require 'active_model'
require 'cgi'
require 'uri'
require 'date'
require 'forwardable'
require 'oauth'
require 'oauth2'
require 'net/http/post/multipart'
require 'quickbooks/util/collection'
require 'quickbooks/util/logging'
require 'quickbooks/util/http_encoding_helper'
require 'quickbooks/util/name_entity'
require 'quickbooks/util/query_builder'
require 'quickbooks/faraday/middleware/gzip'

#== OAuth Responses
require 'quickbooks/service/responses/oauth_http_response'
require 'quickbooks/service/responses/methods'
require 'quickbooks/service/responses/oauth1_http_response'
require 'quickbooks/service/responses/oauth2_http_response'

#== Models
require 'quickbooks/model/definition'
require 'quickbooks/model/validator'
require 'quickbooks/model/base_model'
require 'quickbooks/model/base_model_json'
require 'quickbooks/model/base_reference'
require 'quickbooks/model/document_numbering'
require 'quickbooks/model/global_tax_calculation'
require 'quickbooks/model/has_line_items'
require 'quickbooks/model/name_value'
require 'quickbooks/model/access_token_response'
require 'quickbooks/model/meta_data'
require 'quickbooks/model/class'
require 'quickbooks/model/entity_ref'
require 'quickbooks/model/attachable_ref'
require 'quickbooks/model/attachable'
require 'quickbooks/model/custom_field'
require 'quickbooks/model/sales_item_line_detail'
require 'quickbooks/model/sub_total_line_detail'
require 'quickbooks/model/description_line_detail'
require 'quickbooks/model/department'
require 'quickbooks/model/discount_line_detail'
require 'quickbooks/model/discount_override'
require 'quickbooks/model/payment_line_detail'
require 'quickbooks/model/account_based_expense_line_detail'
require 'quickbooks/model/item_based_expense_line_detail'
require 'quickbooks/model/linked_transaction'
require 'quickbooks/model/tax_line_detail'
require 'quickbooks/model/tax_line'
require 'quickbooks/model/transaction_tax_detail'
require 'quickbooks/model/entity'
require 'quickbooks/model/journal_entry_line_detail'
require 'quickbooks/model/line_ex'
require 'quickbooks/model/line'
require 'quickbooks/model/journal_entry'
require 'quickbooks/model/item_group_line'
require 'quickbooks/model/item_group_detail'
require 'quickbooks/model/item'
require 'quickbooks/model/budget_line_item'
require 'quickbooks/model/budget'
require 'quickbooks/model/account'
require 'quickbooks/model/check_payment'
require 'quickbooks/model/deposit_line_detail'
require 'quickbooks/model/deposit_line_item'
require 'quickbooks/model/deposit'
require 'quickbooks/model/credit_card_payment'
require 'quickbooks/model/telephone_number'
require 'quickbooks/model/other_contact_info'
require 'quickbooks/model/email_address'
require 'quickbooks/model/web_site_address'
require 'quickbooks/model/physical_address'
require 'quickbooks/model/invoice_line_item'
require 'quickbooks/model/invoice_group_line_detail'
require 'quickbooks/model/company_info'
require 'quickbooks/model/company_currency'
require 'quickbooks/model/customer'
require 'quickbooks/model/delivery_info'
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
require 'quickbooks/model/exchange_rate'
require 'quickbooks/model/term'
require 'quickbooks/model/markup_info'
require 'quickbooks/model/group_line_detail'
require 'quickbooks/model/item_based_expense_line_detail'
require 'quickbooks/model/time_activity'
require 'quickbooks/model/purchase_line_item'
require 'quickbooks/model/purchase'
require 'quickbooks/model/purchase_order'
require 'quickbooks/model/vendor_credit'
require 'quickbooks/model/estimate'
require 'quickbooks/model/invoice'
require 'quickbooks/model/effective_tax_rate'
require 'quickbooks/model/tax_rate'
require 'quickbooks/model/tax_rate_detail'
require 'quickbooks/model/tax_rate_detail_line'
require 'quickbooks/model/sales_tax_rate_list'
require 'quickbooks/model/purchase_tax_rate_list'
require 'quickbooks/model/tax_agency'
require 'quickbooks/model/tax_service'
require 'quickbooks/model/tax_code'
require 'quickbooks/model/fault'
require 'quickbooks/model/refund_receipt'
require 'quickbooks/model/batch_request'
require 'quickbooks/model/batch_response'
require 'quickbooks/model/preferences'
require 'quickbooks/model/change_model'
require 'quickbooks/model/invoice_change'
require 'quickbooks/model/customer_change'
require 'quickbooks/model/vendor_change'
require 'quickbooks/model/item_change'
require 'quickbooks/model/report'
require 'quickbooks/model/credit_memo_change'
require 'quickbooks/model/payment_change'
require 'quickbooks/model/transfer'
require 'quickbooks/model/change_data_capture'
require 'quickbooks/model/refund_receipt_change'

#== Services
require 'quickbooks/service/service_crud'
require 'quickbooks/service/service_crud_json'
require 'quickbooks/service/base_service'
require 'quickbooks/service/base_service_json'
require 'quickbooks/service/access_token'
require 'quickbooks/service/class'
require 'quickbooks/service/attachable'
require 'quickbooks/service/company_info'
require 'quickbooks/service/company_currency'
require 'quickbooks/service/customer'
require 'quickbooks/service/department'
require 'quickbooks/service/invoice'
require 'quickbooks/service/deposit'

require 'quickbooks/service/item'
require 'quickbooks/service/budget'
require 'quickbooks/service/journal_entry'
require 'quickbooks/service/sales_receipt'
require 'quickbooks/service/account'
require 'quickbooks/service/payment_method'
require 'quickbooks/service/credit_memo'
require 'quickbooks/service/bill'
require 'quickbooks/service/bill_payment'
require 'quickbooks/service/vendor'
require 'quickbooks/service/employee'
require 'quickbooks/service/exchange_rate'
require 'quickbooks/service/payment'
require 'quickbooks/service/term'
require 'quickbooks/service/time_activity'
require 'quickbooks/service/purchase'
require 'quickbooks/service/purchase_order'
require 'quickbooks/service/vendor_credit'
require 'quickbooks/service/estimate'
require 'quickbooks/service/tax_rate'
require 'quickbooks/service/tax_code'
require 'quickbooks/service/tax_agency'
require 'quickbooks/service/tax_service'
require 'quickbooks/service/batch'
require 'quickbooks/service/preferences'
require 'quickbooks/service/refund_receipt'
require 'quickbooks/service/change_service'
require 'quickbooks/service/invoice_change'
require 'quickbooks/service/customer_change'
require 'quickbooks/service/upload'
require 'quickbooks/util/multipart'
require 'quickbooks/service/vendor_change'
require 'quickbooks/service/item_change'
require 'quickbooks/service/reports'
require 'quickbooks/service/credit_memo_change'
require 'quickbooks/service/payment_change'
require 'quickbooks/service/transfer'
require 'quickbooks/service/change_data_capture'
require 'quickbooks/service/refund_receipt_change'

# Register Faraday Middleware
Faraday::Middleware.register_middleware :gzip => lambda { Gzip }

module Quickbooks
  @@sandbox_mode = false
  @@logger = nil

  class << self
    def sandbox_mode
      @@sandbox_mode
    end

    def sandbox_mode=(sandbox_mode)
      @@sandbox_mode = sandbox_mode
    end

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

  class Error < StandardError; end
  class InvalidModelException < Error; end
  class AuthorizationFailure < Error; end
  class Forbidden < Error; end
  class NotFound < Error; end
  class RequestTooLarge < Error; end
  class ThrottleExceeded < Forbidden; end
  class TooManyRequests < Error; end
  class ServiceUnavailable < Error; end
  class MissingRealmError < Error; end

  class IntuitRequestException < Error
    attr_accessor :message, :code, :detail, :type, :request_xml, :request_json

    def initialize(msg)
      self.message = msg
      super(msg)
    end
  end

  class InvalidOauthAccessTokenObject < StandardError
    def initialize(access_token)
      super("Expected access token to be an instance of OAuth::AccessToken or OAuth2::AccessToken, got #{access_token.class}.")
    end
  end

end
