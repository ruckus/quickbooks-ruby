module Quickbooks
  module Model
    class BaseModel
      include Definition
      include ActiveModel::AttributeMethods
      include ActiveModel::Validations
      include Validator
      include ROXML

      xml_convention :camelcase

      def initialize(attributes={})
        attributes.each {|key, value| public_send("#{key}=", value) }
      end

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

      def as_json(options = nil)
        options = {} if options.nil?
        except_conditions = ["roxml_references"]
        except_conditions << options[:except]
        options[:except] = except_conditions.flatten.uniq.compact
        super(options)
      end

      def to_xml_ns(options = {})
        to_xml_inject_ns(self.class::XML_NODE, options)
      end

      delegate :[], :fetch, :to => :attributes

      def attributes
        attributes = self.class.attribute_names.map do |name|
          value = public_send(name)
          value = value.attributes if value.respond_to?(:attributes)
          [name, value]
        end

        HashWithIndifferentAccess[attributes]
      end

      def inspect
        # it would be nice if we could inspect all the children,
        # but it's likely to blow the stack in some cases
        "#<#{self.class} " +
        "#{attributes.map{|k,v| "#{k}: #{v.nil? ? 'nil' : v.to_s }"}.join ", "}>"
      end
      class << self
        def to_xml_big_decimal
          Proc.new { |val| val.nil? ? nil : val.to_f }
        end

        def attribute_names
          roxml_attrs.map(&:accessor)
        end

        # These can be over-ridden in each model object as needed
        def resource_for_collection
          self::REST_RESOURCE
        end

        def resource_for_singular
          self::REST_RESOURCE
        end

        # Automatically generate an ID setter.
        # Example:
        #   reference_setters :discount_ref
        # Would generate a method like:
        # def discount_id=(id)
        #    self.discount_ref = BaseReference.new(id)
        # end
        def reference_setters(*args)
          references = args.empty? ? reference_attrs : args

          references.each do |attribute|
            last_index = attribute.to_s.rindex('_ref')
            field_name = !last_index.nil? ? attribute.to_s.slice(0, last_index) : attribute
            method_name = "#{field_name}_id=".to_sym
            unless instance_methods(false).include?(method_name)
              method_definition = <<-METH
              def #{method_name}(id)
                self.#{attribute} = BaseReference.new(id)
              end
              METH
              class_eval(method_definition)
            end
          end
        end

        def reference_attrs
          matches = roxml_attrs.select{|attr| attr.sought_type == Quickbooks::Model::BaseReference}.map{|attr| attr.accessor}
        end

        def inspect
          "#{super}(#{attrs_with_types.join " "})"
        end

        def attrs_with_types
          roxml_attrs.map do |attr|
            "#{attr.accessor}:" +
              "#{attr.class.block_shorthands.invert[attr.blocks.last]}:#{attr.sought_type}"
          end
        end
      end
    end
  end
end
