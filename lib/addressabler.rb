require 'rubygems'
require 'addressable/uri'
require 'addressabler/query'

module Addressabler
  module ClassMethods
    def parse_tld(host)
      host = host.to_s.split('.')
      tlds = []
      sub_hash = Addressabler::TLDS
      while sub_hash = sub_hash[tld = host.pop]
        tlds.unshift(tld)
        if sub_hash.has_key? '*'
          tlds.unshift(host.pop)
        end
      end
      tlds.join('.')
    end
  end

  module InstanceMethods
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
      self.class.parse_tld(host)
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

  # Thanks Domainatrix for the parsing logic!
  tlds = {}
  File.readlines(File.join(File.dirname(__FILE__), 'tlds')).each do |line|
    line.strip!
    unless line == '' || line =~ /^\//
      parts = line.split(".").reverse
      sub_hash = tlds
      parts.each do |part|
        sub_hash = (sub_hash[part] ||= {})
      end
    end
  end
  TLDS = tlds
end

Addressable::URI.extend Addressabler::ClassMethods
Addressable::URI.send :include, Addressabler::InstanceMethods
