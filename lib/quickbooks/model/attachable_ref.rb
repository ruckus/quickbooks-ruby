require 'quickbooks/model/entity_ref'
require 'quickbooks/model/custom_field'

module Quickbooks
  module Model
    class AttachableRef < BaseModel
      xml_accessor :entity_ref, :as => BaseReference
      xml_accessor :line_info
      xml_accessor :include_on_send?
      xml_accessor :inactive?
      xml_accessor :no_ref_only?
      xml_accessor :custom_fields, :as => [CustomField]

      def initialize(an_entity_ref = nil)
        if an_entity_ref
          self.entity_ref = an_entity_ref
        end
      end

    end
  end
end
