module Quickbooks
  module Model
    class TelephoneNumber < BaseModel
      xml_accessor :free_form_number, :from => 'FreeFormNumber'
    end
  end
end
