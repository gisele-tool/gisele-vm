require File.expand_path('../spec_helper', __FILE__)
describe Gisele::VM do

  it "should have a version number" do
    Gisele::VM.const_defined?(:VERSION).should be_true
  end

end