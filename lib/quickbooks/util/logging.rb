module Quickbooks
  module Util
    module Logging
      def log(msg)
        ::Quickbooks.log(msg)
      end

      def log_multiple(messages)
        if condense_logs?
          log(messages.join("\n"))
        else
          messages.each(&method(:log))
        end
      end

      def log?
        ::Quickbooks.log?
      end

      def condense_logs?
        ::Quickbooks.condense_logs?
      end

      def log_xml(str)
        if ::Quickbooks.log_xml_pretty_print? && !(str and str.empty?)
          Nokogiri::XML(str).to_xml
        else
          str
        end
      rescue => e
        e
      end
    end
  end
end
