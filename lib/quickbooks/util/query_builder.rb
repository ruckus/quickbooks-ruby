require 'uri'

module Quickbooks
  module Util
    class QueryBuilder

      VALUE_QUOTE = "'"

      def initialize
      end

      def clause(field, operator, value)
        # escape single quotes with an escaped backslash
        value = value.gsub("'", "\\\\'")

        "#{field} #{operator} #{VALUE_QUOTE}#{value}#{VALUE_QUOTE}"
      end

    end
  end
end