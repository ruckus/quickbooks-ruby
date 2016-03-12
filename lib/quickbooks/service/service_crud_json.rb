module Quickbooks
  module Service
    module ServiceCrudJSON

      def fetch_by_id(id, params = {})
        raise NotImplementedError
      end

      def create(entity, options = {})
        raise Quickbooks::InvalidModelException.new(entity.errors.full_messages.join(',')) unless entity.valid?
        response = do_http(:post, url_for_resource(model.resource_for_singular), entity.to_json, options)
        if response.code.to_i == 200
          JSON.parse(response.plain_body)
        else
          nil
        end
      end
      alias :update :create

      def delete
        raise NotImplementedError
      end

      def delete_by_query_string
        raise NotImplementedError
      end

    end
  end
end

