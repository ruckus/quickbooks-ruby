module Quickbooks
  module Model
    module ActiveRecordScaffold

      def self.included(base)
        base.extend(ClassMethods)
      end

      def save(options = {})
        if id.blank?
          self.class.send(:initialize_service).create(self, options)
        else
          self.class.send(:initialize_service).update(self, options)
        end
      end

      module ClassMethods
        def all(query = nil, options = {})
          initialize_service(options).query(query, options).entries
        end

        def first
          all.first
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

        def query_in_batches(options = {})
          initialize_service(options).query_in_batches(query, options).entries
        end

        private

        def initialize_service(options = {})
          if Quickbooks::Configuration.qb_oauth_consumer.blank?
            raise "QB_OAUTH_CONSUMER not set. Please follow instructions at " +
              "https://github.com/ruckus/quickbooks-ruby#getting-started--initiating-authentication-flow-with-intuit"
          end
          service              = eval("Quickbooks::Service::#{model}").new
          service.access_token = OAuth::AccessToken.new(
            Quickbooks::Configuration.qb_oauth_consumer, options[:token] || get_token,
            options[:secret] || get_secret
          )
          service.company_id   = options[:realm_id] || get_realm_id
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

        def get_token
          Quickbooks::Configuration.qb_token_scope == :thread ? Thread.current[:token] : Quickbooks::Configuration.qb_token
        end

        def get_secret
          Quickbooks::Configuration.qb_token_scope == :thread ? Thread.current[:secret] : Quickbooks::Configuration.qb_secret
        end

        def get_realm_id
          Quickbooks::Configuration.qb_token_scope == :thread ? Thread.current[:realm_id] : Quickbooks::Configuration.qb_realm_id
        end
      end
    end
  end
end