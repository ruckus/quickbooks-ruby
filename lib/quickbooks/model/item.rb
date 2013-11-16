module Quickbooks
  module Model
    class Item < BaseModel

      XML_COLLECTION_NODE = "Item"

      xml_name 'Item'
      xml_accessor :name, :from => 'Name'
      xml_accessor :id, :from => '@id' # Attribute with name 'idDomain'
      #xml_accessor :value, :from => :content


      def say
        "hello, #{name}"
      end

    end
  end
end