require 'addressabler'

describe Addressabler do
  it "should still let me parse a URI" do
    uri = Addressable::URI.parse("http://www.google.com/path?foo=bar#anchor")
    uri.should be_instance_of(Addressable::URI)
  end
  
  it "should get the scheme of a URI" do
    uri = Addressable::URI.parse("http://www.google.com/path?foo=bar#anchor")
    uri.scheme.should == "http"
  end
  
  it "should support a TLD" do
    uri = Addressable::URI.parse("http://www.google.com/path?foo=bar#anchor")
    uri.tld.should == 'com'
  end
  
  it "should support wonky TLDs" do
    uri = Addressable::URI.parse("http://www.foo.bar.baz.co.uk/gjadgsg#sdgs?adg=f")
    uri.tld.should == 'co.uk'
  end

  it "should support adding keys to the query" do
    uri = Addressable::URI.parse("http://www.foo.bar.baz.co.uk/gjadgsg?adg=f")
    uri.query_hash.should == {'adg' => 'f'}
    uri.query_hash[:foo] = "bar"
    uri.to_s.should == "http://www.foo.bar.baz.co.uk/gjadgsg?adg=f&foo=bar"
  end

  it "should support adding nested values to the query" do
    uri = Addressable::URI.parse("http://www.amazon.ca")
    uri.query_hash[:foo] = {:bar => :baz}
    uri.to_s.should == "http://www.amazon.ca?foo[bar]=baz"
  end
  
  it "should support subdomains" do
    uri = Addressable::URI.heuristic_parse("i.am.a.subdomain.co.uk")
    uri.subdomain.should == "i.am.a"
  end
  
  it "should support domains" do
    uri = Addressable::URI.heuristic_parse("i.am.a.subdomain.co.uk")
    uri.domain.should == "subdomain"
  end

  it "should change stuff when the host changes" do
    uri = Addressable::URI.heuristic_parse("www.google.com")
    uri.tld.should == 'com'
    uri.domain.should == 'google'
    uri.subdomain.should == 'www'
    uri.host = 'www2.google.co.uk'
    uri.tld.should == 'co.uk'
    uri.domain.should == 'google'
    uri.subdomain.should == 'www2'
  end

  it "should let me change the subdomain" do
    uri = Addressable::URI.heuristic_parse("www.google.com")
    uri.subdomain = 'www2'
    uri.to_s.should == 'http://www2.google.com'
  end

  it "should let me change the domain" do
    uri = Addressable::URI.heuristic_parse("www.google.com")
    uri.domain = 'amazon'
    uri.to_s.should == 'http://www.amazon.com'
  end

  it "should let me change the tld" do
    uri = Addressable::URI.heuristic_parse("www.google.com")
    uri.tld = 'co.uk'
    uri.to_s.should == 'http://www.google.co.uk'
  end

  it "should handle things with no subdomain" do
    uri = Addressable::URI.parse("http://google.com")
    uri.host.should == "google.com"
    uri.domain.should == "google"
    uri.tld.should == "com"
    uri.subdomain.should == ""
  end

  it "should handle empty strings" do
    uri = Addressable::URI.parse("")
    uri.host.should be_nil
    uri.domain.should be_nil
    uri.tld.should be_nil
    uri.subdomain.should be_nil
  end
end
