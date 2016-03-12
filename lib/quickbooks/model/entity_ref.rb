module Quickbooks
  module Model
    class EntityRef < BaseModel
      xml_accessor :type
      xml_accessor :value
    end
  end
end
