module Quickbooks
  module Model
    class Fault < BaseModel
      class Error
        include ROXML
        xml_name 'Error'
        xml_accessor :code, :from => "@code"
        xml_accessor :element, :from => "@element"
        xml_accessor :message, :from => "Message"
        xml_accessor :detail, :from => "Detail"
      end

      xml_accessor :errors, :as => [Quickbooks::Model::Fault::Error]
    end
  end
end
