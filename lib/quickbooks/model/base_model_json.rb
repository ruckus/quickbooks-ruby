module Quickbooks
  module Model
    class BaseModelJSON < BaseModel

      def to_json
        params = {}
        attributes.each_pair do |k, v|
          next if v.blank?
          params[k.camelize] = v.is_a?(Array) ? v.inject([]){|mem, item| mem << item.to_json; mem} : v
        end
        params.to_json
      end

    end
  end
end
