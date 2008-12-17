class Member
  include DataMapper::Resource
  
  property :id, Serial
  property :login, String, :unique => true
  property :firstname, String, :nullable => false
  property :lastname, String, :nullable => false
  property :email, String, :nullable => false, :format => :email_address
  property :birthdate, Date
  property :occupation, String
  property :address, String
  property :city, String
  property :phone_number, String
  property :website, String
  property :subscription_on, Date

  belongs_to :function

  def admin?
    if function
      return function.admin?
    else
      return false
    end
  end

end
