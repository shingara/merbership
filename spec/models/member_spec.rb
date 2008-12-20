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

  describe '#notified?' do

    before :each do
      @member = create_default_member
      create_setting
      # Setting gen has notified to 10 month
    end

    it 'should notified true because month_subscription is less than time where his subscription made' do
      @member.subscription_on = 11.month.ago
      @member.save
      @member.should be_notified
    end

    it 'should notified false because month_subscription is less than time where his subscription made' do
      @member.subscription_on = 9.month.ago
      @member.save
      @member.should_not be_notified
    end

  end

  describe '#out_subscription?' do

    before :each do
      @member = create_default_member
      create_setting
      # Setting gen has out_subscription to 12 month
    end

    it 'should notified true because month_subscription is less than time where his subscription made' do
      @member.subscription_on = 13.month.ago
      @member.save
      @member.should be_out_subscription
    end

    it 'should notified false because month_subscription is less than time where his subscription made' do
      @member.subscription_on = 9.month.ago
      @member.save
      @member.should_not be_out_subscription
    end

  end

end
