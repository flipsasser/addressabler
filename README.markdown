Addressabler
=

**Addressabler** extends the Addressable::URI class by adding TLD parsing, domain and subdomain parsing, and query modification.

Install
==

Install using Rubygems:

	gem install addressabler

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

You can set these values, as well:

	@uri.tld = "org"
	@uri.host #=> "www.google.org"
	@uri.domain = "amazon"
	@uri.host #=> "www.amazon.org"
	@uri.subdomain = "developers"
	@uri.host #=> "developers.amazon.org"

Addressabler copies some of Paul Dix's [Domaintrix](https://github.com/pauldix/domainatrix) TLD code to support fancy TLDs, as well:

	@uri.host = "www.google.co.uk"
	@uri.tld #=> "co.uk"

Addressabler also makes editing queries a little bit easier:

	@uri.query_hash[:foo] = :bar
	@uri.to_s #=> "http://www.google.co.uk/?foo=bar"

That's it. Enjoy.
