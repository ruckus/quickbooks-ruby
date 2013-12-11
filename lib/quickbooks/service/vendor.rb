module Quickbooks
   module Service
      class Vendor < BaseService
        include ServiceCrud
        
        def delete(vendor)
          vendor.active = false
          update(vendor, :sparse => true)
        end
        
        private
        
        def default_model_query
          "SELECT * FROM VENDOR"
        end
        
        def model
          Quickbooks::Model::Vendor
        end
      end
   end
end