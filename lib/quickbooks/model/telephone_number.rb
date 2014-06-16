module Quickbooks
  module Model
    class TelephoneNumber < BaseModel
      xml_accessor :free_form_number, :from => 'FreeFormNumber'

      def initialize(number = nil)
        unless number.nil?
          self.free_form_number = number
        end
      end
    end
  end
end
