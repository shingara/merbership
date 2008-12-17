require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Member do

  it "should be admin" do
    Member.gen(:function => Function.gen(:president)).should be_admin
  end

  it "should not be admin" do
    Member.gen.should_not be_admin
  end

end
