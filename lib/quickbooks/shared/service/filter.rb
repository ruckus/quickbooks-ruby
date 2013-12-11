module Quickbooks
  module Shared
    module Service
      class Filter
		
		DATE_FORMAT = '%Y-%m-%d'
        DATE_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%Z'

        attr_reader :type
        attr_accessor :field, :value

        # For Date/Time filtering
        attr_accessor :before, :after

        # For number comparisons
        attr_accessor :gt, :lt, :eq

        def initialize(type, *args)
          @type = type
          if args.first.is_a?(Hash)
            args.first.each_pair do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end
        end

        def to_s
          case @type.to_sym
          when :date
            date_to_s
          when :datetime
            date_time_to_s
          when :text
            text_to_s
          when :boolean
            boolean_to_s
          when :number
            number_to_s
          else
            raise ArgumentError, "Don't know how to generate a Filter for type #{@type}"
          end
        end

        def to_xml
          case @type.to_sym
          when :text
            text_to_xml
          when :boolean
            boolean_to_xml
          when :date
            date_to_xml
          when :datetime
            datetime_to_xml
          when :number
            number_to_xml
          else
            raise ArgumentError, "Don't know how to generate a Filter for type #{@type}"
          end
        end

        private

        def number_to_s
          clauses = []
          if @eq
            clauses << "#{@field} :EQUALS: #{@eq}"
          end
          if @gt
            clauses << "#{@field} :GreaterThan: #{@gt}"
          end
          if @lt
            clauses << "#{@field} :LessThan: #{@lt}"
          end
          clauses.join(" :AND: ")
        end

        def date_to_s
          clauses = []
          if @before
            raise ':before is not a valid Date-like object' unless valid_datetime?(@before)
            clauses << "#{@field} :BEFORE: #{formatted_date(@before)}"
          end
          if @after
            raise ':after is not a valid Date-like object' unless valid_datetime?(@after)
            clauses << "#{@field} :AFTER: #{formatted_date(@after)}"
          end

          if @before.nil? && @after.nil?
            clauses << "#{@field} :EQUALS: #{formatted_date(@value)}"
          end

          clauses.join(" :AND: ")
        end

        def date_time_to_s
          clauses = []
          if @before
            raise ':before is not a valid DateTime-like object' unless valid_datetime?(@before)
            clauses << "#{@field} :BEFORE: #{formatted_datetime(@before)}"
          end
          if @after
            raise ':after is not a valid DateTime-like object' unless valid_datetime?(@after)
            clauses << "#{@field} :AFTER: #{formatted_datetime(@after)}"
          end

          if @before.nil? && @after.nil?
            clauses << "#{@field} :EQUALS: #{formatted_datetime(@value)}"
          end

          clauses.join(" :AND: ")
        end

        def text_to_s
          "#{@field} :EQUALS: #{@value}"
        end

        def text_to_xml
          "<#{@field}>#{CGI::escapeHTML(@value.to_s)}</#{@field}>"
        end

        def boolean_to_s
          "#{@field} :EQUALS: #{@value}"
        end

        def boolean_to_xml
          "<#{@field}>#{CGI::escapeHTML(@value.to_s)}</#{@field}>"
        end

        def number_to_xml
          "<#{@field}>#{CGI::escapeHTML(@value.to_s)}</#{@field}>"
        end

        def date_to_xml
          "<#{@field}>#{formatted_date(@value)}</#{@field}>"
        end

        def datetime_to_xml
          "<#{@field}>#{formatted_datetime(@value)}</#{@field}>"
        end

        def formatted_date(date)
          date.strftime(DATE_FORMAT)
        end

        def formatted_datetime(datetime)
          datetime.strftime(DATE_TIME_FORMAT)
        end

        def valid_datetime?(value)
          value.respond_to?(:strftime)
        end

     end
    end
  end
end
