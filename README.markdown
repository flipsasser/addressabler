Addressabler
=

**Addressabler** extends the Addressable::URI class by adding TLD parsing, domain and subdomain parsing, and query modification.

Install
==

Install using Rubygems:

	gem install addresabler

Then:

	require 'rubygems'
	require 'addressabler'

Addressabler will automatically require `addressable/uri`.

Usage
==

Use Addressable::URI like you normally would:

	@uri = Addressable::URI.parse("http://www.google.com/")
	@uri.host #=> "www.google.com"

Addressabler will add the following properties:

	@uri.tld #=> "com"
	@uri.domain #=> "google"
	@uri.subdomain #=> "www"

Addressabler also makes editing queries a little bit easier:

	@uri.query_hash[:foo] = :bar
	@uri.to_s #=> http://www.google.com/?foo=bar

That's it. Enjoy.
