module Quickbooks
  module Model
    class Fault < BaseModel
      class Error
        include ROXML
        xml_name 'Error'
        xml_accessor :code, :from => "@code"
        xml_accessor :message, :from => "Message"
      end

      xml_accessor :errors, :as => [Quickbooks::Model::Fault::Error]
    end
  end
end
