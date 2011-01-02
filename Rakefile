require 'rake'

require "jeweler"
Jeweler::Tasks.new do |gemspec|
  gemspec.name = "Addressabler"
  gemspec.summary = "An Addressable::URI extension adding support for TLDs and query part editing"
  gemspec.files = Dir["{lib}/**/*", "README.markdown"]
  gemspec.description = %{
    Addressabler extends the Addressable::URI class to provide better information about, and manipulation of, URI strings. It adds a tld method, a domain method,
    and a subdomain method. It also allows users to easily modify the URL's query values as a hash.
  }
  gemspec.email = "flip@x451.com"
  gemspec.homepage = "http://github.com/flipsasser/addressabler"
  gemspec.authors = ["Flip Sasser"]
  gemspec.test_files = Dir["{spec}/**/*"]
  gemspec.add_development_dependency 'rspec', '>= 2.0'
  gemspec.add_dependency 'addressable', '>= 2.2.2'
end
