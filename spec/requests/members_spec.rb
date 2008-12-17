require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a member exists" do
  Member.all.destroy!
  Function.all.destroy!
  Member.gen
  Member.gen(:function => Function.gen(:president))
end

describe "resource(:members)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:members))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of members" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a member exists" do
    before(:each) do
      @response = request(resource(:members))
    end
    
    it "has a list of members" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do

    describe 'with admin user' do
      before(:each) do
        Member.all.destroy!
        login_admin
        @member = Member.make
        @response = request(resource(:members), :method => "POST", 
          :params => { :member => @member.attributes.merge(:password => 'foobar',
                                                                :password_confirmation => 'foobar')})
      end
      
      it "redirects to resource(:members)" do
        @response.should redirect_to(resource(Member.first(:login => @member.login) ), :message => {:notice => "member was successfully created"})
      end
    end

    describe 'with non admin user' do
      before(:each) do
        login_member
      end
      it 'should redirect' do
        lambda {
          @response = request(resource(:members), :method => "POST",
                           :params => { :member => Member.make.attributes.merge(:password => 'foobar', 
                                                                                :password_confirmation => 'foobar') })
          @response.status.should == 401
        }.should_not change(Member, :count)
      end
    end

    describe 'with non logged user' do
      it 'should redirect' do
        lambda {
          @response = request(resource(:members), :method => "POST",
                           :params => { :member => Member.make.attributes.merge(:password => 'foobar', 
                                                                                :password_confirmation => 'foobar') })
          @response.status.should == 401
        }.should_not change(Member, :count)
      end
    end
    
  end
end

describe "resource(@member)" do 
  describe "a successful DELETE", :given => "a member exists" do
    describe 'with admin user' do

     before(:each) do
       login_admin
       @response = request(resource(Member.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:members))
     end

    end

    describe 'with user logged' do
      before(:each) do
        login_member
      end

      it 'should render status 401' do
        @response = request(resource(Member.first), :method => "delete")
        @response.status.should == 401
      end
    end

    describe 'with user non logged' do
      it 'should render status 401' do
        @response = request(resource(Member.first), :method => "delete")
        @response.status.should == 401
      end
    end
  end
end

describe "resource(:members, :new)" do
  describe 'with admin user' do
    before(:each) do
      login_admin
      @response = request(resource(:members, :new))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe 'with no member' do
    it 'should render status 401' do
      @response = request(resource(:members, :new))
      @response.status.should == 401
    end
  end

  describe 'with logged member, not admin' do
    before(:each) do
      login_member
    end

    it 'should render status 401' do
      @response = request(resource(:members, :new))
      @response.status.should == 401
    end
  end

end

describe "resource(@member, :edit)", :given => "a member exists" do
  describe 'with admin user' do

    before(:each) do
      login_admin
      @response = request(resource(Member.first, :edit))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end
  end

  describe 'with logged user' do
    before(:each) do
      Member.gen
      login_member
    end

    it 'should edit his user' do
      @response = request(resource(Member.first(:login => 'oupsnow'), :edit))
      @response.should be_successful
    end

    it 'should not edit other user' do
      @response = request(resource(Member.first(:login.not => 'oupsnow'), :edit))
      @response.status.should == 401
    end

  end

  describe 'with no user logged' do
    it 'should edit his user' do
      @response = request(resource(Member.first, :edit))
      @response.status.should == 401
    end
  end
end

describe "resource(@member)", :given => "a member exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Member.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    describe 'with admin user' do
      before(:each) do
        login_admin
        @member = Member.first
        @response = request(resource(@member), :method => "PUT", 
          :params => { :member => {:id => @member.id, :login => 'yahoo'} })
      end
    
      it "redirect to the article show action" do
        @response.should redirect_to(resource(@member))
      end
    end

    describe 'with user logged' do
      before do
        Member.gen
        login_member
      end

      it 'should update his user' do
        @member = Member.first(:login => 'oupsnow')
        @response = request(resource(@member), :method => "PUT", 
          :params => { :member => {:id => @member.id, :login => 'yahoo'} })
        @response.should redirect_to(resource(@member))
      end

      it 'should no update other user' do
        @member = Member.first(:login.not => 'oupsnow')
        @response = request(resource(@member), :method => "PUT", 
          :params => { :member => {:id => @member.id, :login => 'yahoo'} })
        @response.status.should == 401
      end
    end

    describe 'with user not logged' do
      it 'should not update user' do
        @member = Member.first
        @response = request(resource(@member), :method => "PUT", 
          :params => { :member => {:id => @member.id, :login => 'yahoo'} })
        @response.status.should == 401
      end
    end

  end
  
end

