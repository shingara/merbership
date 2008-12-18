require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Function do

  it "should get all non admin" do
    Function.gen(:president)
    Function.gen(:member)
    Function.not_admin.should have(1).item
  end

end
