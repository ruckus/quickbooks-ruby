module Quickbooks
  module Util
    class ClassUtil
      def self.defined?(class_name)
        begin
          klass = Module.const_get(class_name)
          return klass.is_a?(Class)
        rescue NameError
          return false
        end
      end
    end
  end
end