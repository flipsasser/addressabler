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
      @domain ||= parse_domain_parts[:domain]
    end

    def query_hash
      @query_hash ||= query_hash_for(query_values || {})
    end

    def query_hash=(new_query_hash)
      @query_hash = query_hash_for(new_query_hash || {})
    end

    def subdomain
      @subdomain ||= parse_domain_parts[:subdomain]
    end

    def tld
      @tld ||= parse_domain_parts[:tld]
    end

    private
    def query_hash_for(contents)
      hash = Addressabler::Query[contents]
      hash.uri = self
      hash
    end

    def parse_domain_parts
      return @domain_parts if defined? @domain_parts
      tld = self.class.parse_tld(host)
      begin
        subdomain_parts = host.gsub(/\.#{tld}$/, '').split('.')
      rescue
        raise host.inspect
      end
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
    unless !line.strip! == ''
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
