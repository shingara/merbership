require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Member do

  it "should be admin" do
    Member.gen(:function => Function.gen(:president)).should be_admin
  end

  it "should not be admin" do
    Member.gen.should_not be_admin
  end

  it 'should not change password if define in creation' do
    m = Member.make
    m.save
    m.password.should == 'tintinpouet'
  end

  it 'should change password if not define in creation' do
    m = Member.make(:password => nil, :password_confirmation => nil)
    m.save
    m.password.should_not nil
  end

  it 'should not change password in update' do
    Member.all.destroy!
    Member.gen
    m = Member.first
    m.login.should_not == 'foobar'
    m.login = 'foobar'
    m.save
    Member.authenticate('foobar', 'tintinpouet').should == Member.first(:login => 'foobar')
  end

end
