require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a function exists" do
  Function.all.destroy!
  request(resource(:functions), :method => "POST", 
    :params => { :function => { :id => nil }})
end

describe "resource(:functions)" do

  before(:each) do
    login_admin
  end
  
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:functions))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of functions" do
      @response.should have_xpath("//table/tbody/tr/td")
    end
    
  end
  
  describe "GET", :given => "a function exists" do
    before(:each) do
      login_admin
      @response = request(resource(:functions))
    end
    
    it "has a list of functions" do
      @response.should have_xpath("//table/tbody/tr/td")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      login_admin
      f = Function.first(:name => 'member')
      f.destroy! if f
      @response = request(resource(:functions), :method => "POST", 
        :params => { :function => { :name => 'member' }})
    end
    
    it "redirects to resource(:functions)" do
      @response.should redirect_to(resource(:functions), :message => {:notice => "function was successfully created"})
    end
    
  end
end

describe "resource(@function)" do 
  describe "a successful DELETE", :given => "a function exists" do
     before(:each) do
       login_admin
       @response = request(resource(Function.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:functions))
     end

   end
end

describe "resource(:functions, :new)" do
  before(:each) do
    login_admin
    @response = request(resource(:functions, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@function, :edit)", :given => "a function exists" do
  before(:each) do
    login_admin
    @response = request(resource(Function.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@function)", :given => "a function exists" do
  
  describe "PUT" do
    before(:each) do
      login_admin
      @function = Function.first
      @response = request(resource(@function), :method => "PUT", 
        :params => { :function => {:id => @function.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(:functions))
    end
  end
  
end

