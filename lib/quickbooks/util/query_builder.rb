require 'uri'

module Quickbooks
  module Util
    class QueryBuilder

      VALUE_QUOTE = "'"

      def initialize
      end

      def clause(field, operator, value)
        value = case value
                when DateTime, Time
                  value.iso8601
                when Date
                  value.strftime('%Y-%m-%d')
                else
                  # escape single quotes with an escaped backslash
                  value = value.gsub("'", "\\\\'")
                end

        "#{field} #{operator} #{VALUE_QUOTE}#{value}#{VALUE_QUOTE}"
      end

    end
  end
end
