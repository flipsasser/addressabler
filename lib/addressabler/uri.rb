require 'addressabler'
require 'addressabler/query'
require 'addressable/uri'

module Addressabler
  module URI
    def domain
      return nil unless host
      parse_domain_parts[:domain]
    end

    def domain=(new_domain)
      self.host = "#{subdomain}.#{new_domain}.#{tld}"
    end

    def query_hash
      @query_hash ||= query_hash_for(query_values || {})
    end

    def query_hash=(new_query_hash)
      @query_hash = query_hash_for(new_query_hash || {})
    end

    def subdomain
      return nil unless host
      parse_domain_parts[:subdomain]
    end

    def subdomain=(new_subdomain)
      self.host = "#{new_subdomain}.#{domain}.#{tld}"
    end

    def tld
      return nil unless host
      Addressabler.parse_tld(host)
    end

    def tld=(new_tld)
      self.host = "#{subdomain}.#{domain}.#{new_tld}"
    end

    private
    def query_hash_for(contents)
      hash = Addressabler::Query[contents]
      hash.uri = self
      hash
    end

    def parse_domain_parts
      tld = self.tld
      subdomain_parts = host.to_s.gsub(/\.#{tld}$/, '').split('.')
      @domain_parts = {
        :domain => subdomain_parts.pop,
        :subdomain => subdomain_parts.join('.'),
        :tld => tld
      }
    end
  end

end

Addressable::URI.send :include, Addressabler::URI
