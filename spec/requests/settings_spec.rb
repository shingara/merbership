require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/settings" do


  describe 'GET' do
    before(:each) do
      login_admin
      create_setting
      @response = request("/settings")
    end

    it 'should be successful' do
      @response.should be_successful
    end
  end

  describe 'POST' do
    before(:each) do
      login_admin
      create_setting
      request('/settings', :method => 'GET')
      @response = request("/settings", :method => 'POST', :params => {:setting => {:id => Setting.first.id, :month_subscription => 5}})
    end

    it 'should be successful' do
      @response.should be_successful
    end

    it 'should update setting' do
      Setting.first.month_subscription.should == 5
    end

  end

end
