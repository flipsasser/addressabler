module Addressabler
  class Query < ::Hash
    class << self
      def nested_hash_support?
        return @nested_hash_support if defined?(@nested_hash_support)
        begin
          require 'rack/utils'
          @nested_hash_support = true
        rescue LoadError
          @nested_hash_support = false
        end
      end
    end

    def delete(value)
      super
      update_uri
    end

    def []=(key, value)
      super
      update_uri
    end

    def uri=(uri)
      @uri = uri
      update_uri
    end

    private
    def update_uri
      if self.class.nested_hash_support?
        @uri.query = Rack::Utils.build_nested_query(hash_with_string_values(self))
      else
        @uri.query_values = empty? ? nil : dup
      end
    end

    def array_with_string_values(array)
      array.map do |value|
        case value
        when Array
          array_with_string_values(value)
        when Hash
          hash_with_string_values(Hash)
        else
          value.to_s
        end
      end
    end

    def hash_with_string_values(hash)
      string_values = hash.map do |key, value|
        case value
        when Array
          [key, array_with_string_values(value)]
        when Hash
          [key, hash_with_string_values(value)]
        else
          [key, value.to_s]
        end
      end
      Hash[*string_values.flatten(1)]
    end
  end
end
