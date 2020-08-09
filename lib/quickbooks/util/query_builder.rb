require 'uri'

module Quickbooks
  module Util
    class QueryBuilder

      VALUE_QUOTE = "'"

      def initialize
      end

      def clause(field, operator, value)
        # replace with an escaped backslash
        escape_single_quotes = -> field { field.to_s.gsub("'", "\\\\'") }

        value = case value
                when DateTime, Time
                  value.iso8601
                when Date
                  value.strftime('%Y-%m-%d')
                when Array
                  value = value.map(&escape_single_quotes)
                else
                  value = escape_single_quotes.call(value)
                end

        if operator.downcase == 'in' && value.is_a?(Array)
          value = value.map { |v| "#{VALUE_QUOTE}#{v}#{VALUE_QUOTE}" }
          "#{field} #{operator} (#{value.join(', ')})"
        else
          "#{field} #{operator} #{VALUE_QUOTE}#{value}#{VALUE_QUOTE}"
        end
      end
    end
  end
end
