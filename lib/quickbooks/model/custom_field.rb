module Quickbooks
  module Model
    class CustomField < BaseModel
      xml_accessor :id, :from => 'DefinitionId', :as => Integer
      xml_accessor :name, :from => 'Name'
      xml_accessor :type, :from => 'Type'
      xml_accessor :string_value, :from => 'StringValue'
      xml_accessor :boolean_value, :from => 'BooleanValue'
      xml_accessor :date_value, :from => 'DateValue', :as => Date
      xml_accessor :number_value, :from => 'NumberValue', :as => Integer

      def value
        case type
        when 'BooleanType' then boolean_value == 'true'
        when 'StringType' then string_value
        when 'DateType' then date_value
        when 'NumberType' then number_value
        end
      end

      def value=(value)
        case type
        when 'BooleanType' then self.boolean_value = value ? 'true' : 'false'
        when 'StringType' then self.string_value = value
        when 'DateType' then self.date_value = value
        when 'NumberType' then self.number_value = value
        end
      end
    end
  end
end
