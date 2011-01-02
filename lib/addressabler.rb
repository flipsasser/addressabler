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
    def self.included(base)
      base.class_eval do
        alias_method :original_query, :query
        alias_method :query, :query_hash
        alias_method :original_query=, :query=
        alias_method :query=, :new_query=
        alias_method :original_query_values=, :query_values=
        alias_method :query_values=, :new_query_values=
      end
    end

    def domain
      @domain ||= parse_domain_parts[:domain]
    end

    def new_query=(new_query)
      self.original_query = new_query
      @_original_query = true
      @query_hash = Addressabler::Query[query_values(:notation => :flat) || {}]
      @_original_query = false
    end

    def query_hash
      @_original_query ? original_query : @query_hash ||= Addressabler::Query.new
    end

    def new_query_values=(new_query_values)
      self.original_query_values = new_query_values
      @_original_query = true
      @query_hash = Addressabler::Query[query_values(:notation => :flat) || {}]
      @_original_query = false
    end

    def subdomain
      @subdomain ||= parse_domain_parts[:subdomain]
    end

    def tld
      @tld ||= parse_domain_parts[:tld]
    end

    private
    def parse_domain_parts
      return @_domain_parts if defined? @_domain_parts
      tld = self.class.parse_tld(host)
      begin
        subdomain_parts = host.gsub(/\.#{tld}$/, '').split('.')
      rescue
        raise host.inspect
      end
      @_domain_parts = {
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

Addressable::URI.class_eval do
  alias :original_query :query
end
Addressable::URI.extend Addressabler::ClassMethods
Addressable::URI.send :include, Addressabler::InstanceMethods
