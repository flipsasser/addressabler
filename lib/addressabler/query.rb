module Addressabler
  class Query < ::Hash
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
      @uri.query_values = empty? ? nil : to_hash
    end
  end
end
