require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a function exists" do
  Function.all.destroy!
  request(resource(:functions), :method => "POST", 
    :params => { :function => { :id => nil }})
end

describe "resource(:functions)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:functions))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of functions" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a function exists" do
    before(:each) do
      @response = request(resource(:functions))
    end
    
    it "has a list of functions" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Function.all.destroy!
      @response = request(resource(:functions), :method => "POST", 
        :params => { :function => { :id => nil }})
    end
    
    it "redirects to resource(:functions)" do
      @response.should redirect_to(resource(Function.first), :message => {:notice => "function was successfully created"})
    end
    
  end
end

describe "resource(@function)" do 
  describe "a successful DELETE", :given => "a function exists" do
     before(:each) do
       @response = request(resource(Function.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:functions))
     end

   end
end

describe "resource(:functions, :new)" do
  before(:each) do
    @response = request(resource(:functions, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@function, :edit)", :given => "a function exists" do
  before(:each) do
    @response = request(resource(Function.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@function)", :given => "a function exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Function.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @function = Function.first
      @response = request(resource(@function), :method => "PUT", 
        :params => { :function => {:id => @function.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@function))
    end
  end
  
end

