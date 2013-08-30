require 'addressabler'
require 'addressable/uri'

module Addressabler
  module URIDeprecation
    def custom_tlds
      deprecate_custom_tlds
      Addressabler.custom_tlds
    end

    def custom_tlds=(new_custom_tlds)
      deprecate_custom_tlds
      Addressabler.custom_tlds = new_custom_tlds
    end

    private
    def deprecate_custom_tlds
      Addressabler.deprecation_warning('Addressable::URI.custom_tlds will be replaced with Addressabler.custom_tlds in Addressable 1.0. Please note the deprecated accessor is on "Addressable::URI" and the new accessor is on "Addressable*r*")')
    end
  end
end

Addressable::URI.extend Addressabler::URIDeprecation
