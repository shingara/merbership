require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Setting do

  it "should be valid" do
    Setting.gen.should be_valid
  end

end
