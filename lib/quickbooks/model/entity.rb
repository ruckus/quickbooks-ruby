module Quickbooks
  module Model
    class Entity < BaseModel
      include NameEntity::Quality

      xml_accessor :type, :from => 'Type'
      xml_accessor :entity_ref, :as => BaseReference

      reference_setters :entity_ref

      #== Validations
      validate :entity_type_is_valid

    end
  end
end
