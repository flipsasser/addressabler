require "addressabler"

describe Addressabler do
  describe ".parse_tlds" do
    it "doesn't return private TLDs by default" do
      host = 'fwefweewf.blogspot.com'
      tld = Addressabler.parse_tld(host)
      tld.should == 'com'
    end

    it "can switch private tlds on" do
      Addressabler.use_private_tlds = true
      host = 'fwefweewf.blogspot.com'
      tld = Addressabler.parse_tld(host)
      tld.should == 'blogspot.com'
    end
  end
end
