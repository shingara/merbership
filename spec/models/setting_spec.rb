require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Setting do

  it "should be valid" do
    Setting.gen.should be_valid
  end

  describe 'completed' do
    it 'should complete' do
      Setting.gen.should be_completed
    end
    it 'should not complete if month_subscription blank' do
      Setting.gen(:month_subscription => '').should_not be_completed
    end
    it 'should not complete if month_notification blank' do
      Setting.gen(:month_notification => '').should_not be_completed
    end
    it 'should not complete if name blank' do  
      Setting.gen(:name => '').should_not be_completed
    end
    it 'should not compete if email_admin blank' do
      Setting.gen(:email_admin => '').should_not be_completed
    end
  end

end
