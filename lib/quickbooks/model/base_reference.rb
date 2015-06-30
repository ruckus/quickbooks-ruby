module Quickbooks
  module Model
    class BaseReference < BaseModel
      xml_convention :camelcase
      xml_accessor :name, :from => '@name' # Attribute with name 'name'
      xml_accessor :value, :from => :content
      xml_accessor :type, :from => '@type' # Attribute with name 'type'

      def initialize(attributes={})
        if attributes.kind_of?(Hash)
          attributes.each {|key, value| public_send("#{key}=", value) }
        else
          self.value = attributes
        end
      end

      def to_i
        self.value.to_i
      end

      def to_s
        self.value.to_s
      end
    end
  end
end
