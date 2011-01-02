module Addressabler
  class Query < ::Hash
    STRING_METHODS = "".methods.map(&:to_s)

    def ==(value)
      case value
      when NilClass
        empty?
      when String
        puts "#{to_s.inspect} == #{value.inspect} (#{to_s == value})"
        to_s == value
      else
        super
      end
    end

    def to_s
      if empty?
        ''
      else
        uri = Addressable::URI.new
        uri.query_values = self
        uri.original_query
      end
    end
    alias :to_str :to_s

    private
    def method_missing(method, *args)
      if STRING_METHODS.include? method.to_s
        to_s.send(method, *args)
      else
        super
      end
    end
  end
end
