require 'roxml'
require 'logger'
require 'nokogiri'
require 'logger'
require 'active_model'
require 'cgi'
require 'date'
require 'forwardable'
require 'oauth'
require 'quickbooks/util/logging'
require 'quickbooks/util/class_util'

#== Models
require 'quickbooks/model/base_model'
require 'quickbooks/model/meta_data'
require 'quickbooks/model/custom_field'
require 'quickbooks/model/invoice_item_ref'
require 'quickbooks/model/sales_item_line_detail'
require 'quickbooks/model/sub_total_line_detail'
require 'quickbooks/model/customer_ref'
require 'quickbooks/model/discount_override'
require 'quickbooks/model/payment_line_detail'
require 'quickbooks/model/line'
require 'quickbooks/model/item'

require 'quickbooks/model/telephone_number'
require 'quickbooks/model/email_address'
require 'quickbooks/model/web_site_address'
require 'quickbooks/model/physical_address'
require 'quickbooks/model/linked_transaction'
require 'quickbooks/model/invoice_line_item'
require 'quickbooks/model/invoice'
require 'quickbooks/model/customer'
require 'quickbooks/model/ship_method_ref'
require 'quickbooks/model/payment_method_ref'
require 'quickbooks/model/sales_receipt'
require 'quickbooks/model/payment_method'

#== Services
require 'quickbooks/service/base_service'
require 'quickbooks/service/service_crud'
require 'quickbooks/service/customer'
require 'quickbooks/service/invoice'
require 'quickbooks/service/item'
require 'quickbooks/service/sales_receipt'
require 'quickbooks/service/payment_method'

unless Quickbooks::Util::ClassUtil.defined?("InvalidModelException")
  class InvalidModelException < StandardError; end
end

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
    attr_writer :log

    # Returns whether to log. Defaults to 'false'.
    def log?
      @log ||= false
    end

    def log(msg)
      if log?
        logger.info(msg)
        logger.flush if logger.respond_to?(:flush)
      end
    end
  end # << self

  class Collection
    attr_accessor :entries

    # Legacy Attributes (v2)
    attr_accessor :count, :current_page

    # v3 Attributes
    attr_accessor :start_position, :max_results, :total_count
  end

end
