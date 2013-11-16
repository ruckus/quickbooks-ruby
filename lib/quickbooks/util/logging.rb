module Quickbooks
  module Util
    module Logging
      def log(msg)
        ::Quickbooks.log(msg)
      end
    end
  end
end
