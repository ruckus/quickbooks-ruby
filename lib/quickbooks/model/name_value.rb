module Quickbooks
  module Model
    class NameValue < BaseModel
      xml_accessor :name, :from => "Name"
      xml_accessor :value, :from => "Value"
    end
  end
end
