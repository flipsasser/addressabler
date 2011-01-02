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
end
