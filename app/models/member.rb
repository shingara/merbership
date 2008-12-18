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

  before :create, :generate_password

  def admin?
    if function
      return function.admin?
    else
      return false
    end
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  private

  # Generate a password if no password define. This password if generate by
  # rangexp. A gem require by dm-sweatshop. If password no send after by mail,
  # the password is not getting another time.
  def generate_password
    self.password = self.password_confirmation = /\w{0,10}/.gen unless password
  end

end
