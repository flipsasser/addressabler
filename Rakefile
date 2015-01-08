require "jeweler"

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "addressabler"
  gemspec.summary = "An Addressable::URI extension adding support for TLDs and query part editing"
  gemspec.files = Dir["{lib}/**/*", "CHANGELOG.md", "LICENSE", "README.markdown"]
  gemspec.description = %{
    Addressabler extends the Addressable::URI class to provide information about, and manipulation of, specific parts of URI strings. It adds a `tld' method, a `domain' method,
    and a `subdomain' method.

It also allows users to easily modify the URL's query values as a hash.
  }
  gemspec.email = "flip@x451.com"
  gemspec.homepage = "http://github.com/flipsasser/addressabler"
  gemspec.authors = ["Flip Sasser"]
  gemspec.test_files = Dir["{spec}/**/*"]
end

desc "Update TLD list"
task :update_tlds do
  `curl https://publicsuffix.org/list/effective_tld_names.dat > lib/tlds`
end
