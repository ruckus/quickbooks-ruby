module Quickbooks
  class Configuration
    class << self
      attr_accessor :qb_oauth_consumer, :qb_token_scope, :qb_token, :qb_secret, :qb_realm_id
    end

    def self.set_tokens_and_realm_id(token, secret, realm_id, options = {})
      options[:scope] ||= :thread
      if options[:scope] == :thread
        Thread.current[:token]    = token
        Thread.current[:secret]   = secret
        Thread.current[:realm_id] = realm_id
        self.qb_token_scope       = :thread
      else
        self.qb_token       = token
        self.qb_secret      = secret
        self.qb_realm_id    = realm_id
        self.qb_token_scope = :application
      end
    end

    def self.set_oauth_consumer(oauth_consumer)
      self.qb_oauth_consumer = oauth_consumer
    end
  end
end