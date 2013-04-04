# Addressabler

**Addressabler** extends the [Addressable::URI][] class by adding TLD parsing,
domain and subdomain parsing, query modification, and restoring setting of
nested hashes to query strings.

## Install

Install using Rubygems:

	gem install addressabler

Then:

	require 'rubygems'
	require 'addressabler'

Addressabler will automatically require `addressable/uri`.

## Usage

### Domain, TLD, and subdomain parsing

Use `Addressable::URI` like you normally would:

```ruby
@uri = Addressable::URI.parse("http://www.google.com/")
@uri.host #=> "www.google.com"
```

Addressabler will add the following properties:

```ruby
@uri.tld #=> "com"
@uri.domain #=> "google"
@uri.subdomain #=> "www"
```

You can set these values, as well:

```ruby
@uri.tld = "org"
@uri.host #=> "www.google.org"
@uri.domain = "amazon"
@uri.host #=> "www.amazon.org"
@uri.subdomain = "developers"
@uri.host #=> "developers.amazon.org"
```

#### Complex TLD support (thanks to Paul Dix!)
Addressabler copies some of Paul Dix's [Domaintrix][] TLD code to support fancy
TLDs, as well:

```ruby
@uri.host = "www.google.co.uk"
@uri.tld #=> "co.uk"
```

#### Custom TLDs
You can specify custom TLDs - which aren't actually working TLD's on the
internet - for internal usage. One example would be a custom development TLD:

```ruby
Addressable::URI.custom_tlds = {
  'dev' => {},              # mydomain.dev
  'bar' => { 'foo' => {} }  # mydomain.foo.bar
}
```

### Query interface

Addressabler adds a `query_hash` method to `Addressable::URI`s. This makes
editing query strings a lot simpler, using a familiar Hash syntax:

```ruby
@uri.query_hash[:foo] = :bar
@uri.to_s #=> "http://www.google.co.uk/?foo=bar"
```

#### Nested hashes in query strings

The current maintainer of Addressable, [Bob Aman][], feels rather strongly that
[Rails got it wrong][] in supporting nested hashes in query strings.

Frankly, I don't disagree with anything he has to say on the issue, but it is a
problem many people have experienced.

*As such,* since Rack already supports building nested hashes "the Rails Way"
(shudder), I added support for assigning nested hashes to `URI`s **only if Rack
is available.** Addressabler will attempt to load `Rack::Utils` and, if it finds
it, you can assign a nested hash in the `query_hash=` method like so:

```ruby
@uri.query_hash = {:foo => {:bar => :baz}}
@uri.to_s #=> "http://www.google.co.uk/?foo[bar]=baz"
```

**HANDLE WITH CARE!** As [Bob explains in the discussion][], there's a better
alternative to nested hashes in query strings, so try that before you install
this library.

That's it. Enjoy.

#### Copyright &copy; 2013 Flip Sasser


[Addressable::URI]: https://github.com/sporkmonger/addressable
[Domaintrix]: https://github.com/pauldix/domainatrix
[Bob Aman]: https://github.com/sporkmonger
[Rails got it wrong]: https://github.com/sporkmonger/addressable/issues/77
[Bob explains in the discussion]: https://github.com/sporkmonger/addressable/issues/77#issuecomment-8534480
