module Quickbooks
  module Model
    class BaseModel
      include ActiveModel::Validations
      include ROXML
      xml_convention :camelcase

      # ROXML doesnt insert the namespaces into generated XML so we need to do it ourselves
      # insert the static namespaces in the first opening tag that matches the +model_name+
      def to_xml_inject_ns(model_name, options = {})
        s = StringIO.new
        xml = to_xml(options).write_to(s, :indent => 0, :indent_text => '')
        destination_name = options.fetch(:destination_name, nil)
        destination_name ||= model_name

        sparse = options.fetch(:sparse, false)
        sparse_string = %{sparse="#{sparse}"}
        step1 = s.string.sub("<#{model_name}>", "<#{destination_name} #{Quickbooks::Service::BaseService::XML_NS} #{sparse_string}>")
        step2 = step1.sub("</#{model_name}>", "</#{destination_name}>")
        step2
      end

      def to_xml_ns(options = {})
        to_xml_inject_ns(self.class::XML_NODE, options)
      end

      class << self

        # These can be over-ridden in each model object as needed
        def resource_for_collection
          self::REST_RESOURCE
        end

        def resource_for_singular
          self::REST_RESOURCE
        end

      end
    end
  end
end