
module Quickbooks
  module Model
    class LineEx < BaseModel

      xml_accessor :name_values, :from => "NameValue", :as => [NameValue]
    end
  end
end
