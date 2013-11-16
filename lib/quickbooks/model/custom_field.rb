module Quickbooks
  module Model
    class CustomField < BaseModel
      xml_accessor :id, :from => 'Id'
      xml_accessor :name, :from => 'Name'
      xml_accessor :type, :from => 'Type'
    end
  end
end