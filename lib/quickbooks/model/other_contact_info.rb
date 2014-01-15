module Quickbooks
  module Model
    class OtherContactInfo < BaseModel
      xml_accessor :type, :from => 'Type'
      xml_accessor :telephone, :from => 'Telephone', :as => TelephoneNumber
    end
  end
end
