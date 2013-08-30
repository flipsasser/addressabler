require 'addressabler/uri_deprecation'

describe Addressabler, "deprecation" do
  describe "TLDS" do
    it "returns public TLDS" do
      Addressabler::TLDS.should == Addressabler.public_tlds
    end

    it "warns about the deprecated TLD constant" do
      Addressabler.should_receive(:deprecation_warning)
      Addressabler::TLDS
    end
  end
end

describe Addressable::URI, "deprecation" do
  describe "custom_tlds" do
    it "returns the Addressabler custom_tlds" do
      Addressabler.custom_tlds = {foo: "bar"}
      Addressable::URI.custom_tlds.should == {foo: "bar"}
    end

    it "sets the Addressabler custom_tlds" do
      Addressable::URI.custom_tlds = {gert: "B. Frobe"}
      Addressabler.custom_tlds.should == {gert: "B. Frobe"}
    end

    it "warns about the deprecated custom_tlds getter" do
      Addressabler.should_receive(:deprecation_warning)
      Addressable::URI.custom_tlds
    end

    it "warns about the deprecated custom_tlds setter" do
      Addressabler.should_receive(:deprecation_warning)
      Addressable::URI.custom_tlds = {bring_me: "a sandwich"}
    end
  end

end
