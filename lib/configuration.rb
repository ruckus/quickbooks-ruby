module Quickbooks
  class Configuration
    def self.set_tokens_and_realm_id(token, secret, realm_id, options = {})
      options[:scope] ||= :thread
      if options[:scope] == :thread
        Thread.current[:token]    = token
        Thread.current[:secret]   = secret
        Thread.current[:realm_id] = realm_id
        QB_TOKENS_SCOPE = :thread
      else
        QB_TOKEN    = token
        QB_SECRET   = secret
        QB_REALM_ID = realm_id
        QB_TOKENS_SCOPE = :application
      end
    end

    def self.set_oauth_consumer(oauth_consumer)
      ::QB_OAUTH_CONSUMER = oauth_consumer
    end
  end
end