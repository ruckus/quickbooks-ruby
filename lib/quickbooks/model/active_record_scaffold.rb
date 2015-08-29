module Quickbooks
  module Model
    module ActiveRecordScaffold

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def all(query = nil, options = {})
          initialize_service(options).query(query, options).entries
        end

        def where(options = {})
          if options.is_a?(String)
            all(build_string_query(options), {})
          elsif options.present?
            all(build_hash_query(options.except(:skip_pagination)), options)
          else
            all(full_query, {})
          end
        end

        def find_by(options = {})
          where(options).first
        end

        def find(id)
          find_by(id: id)
        end

        def count
          initialize_service.query("SELECT COUNT(*) FROM #{model}").total_count
        end

        private

        def initialize_service(options = {})
          service              = eval("Quickbooks::Service::#{model}").new
          service.access_token = OAuth::AccessToken.new(
            $qb_oauth_consumer, options[:token] || Thread.current[:token],
            options[:secret] || Thread.current[:secret]
          )
          service.company_id   = options[:realm_id] || Thread.current[:realm_id]
          service
        end

        def build_string_query(query = nil)
          unless query.downcase.starts_with?('select ')
            query = query.present? ? "#{conditional_query} #{query}" : full_query
          end
          query
        end

        def build_hash_query(options = {})
          query_builder = Quickbooks::Util::QueryBuilder.new
          conditions = options.collect do |key, value|
            if value.is_a?(Array)
              query_builder.clause(key, 'IN', value)
            else
              query_builder.clause(key, '=', value)
            end
          end.join(' AND ')
          conditional_query + conditions
        end

        def conditional_query
          "#{full_query} WHERE "
        end

        def full_query
          "SELECT * FROM #{model}"
        end

        def model
          self.name.split('::').last
        end
      end
    end
  end
end