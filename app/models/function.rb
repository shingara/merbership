class Function
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :nullable => false, :unique => true
  property :admin, Boolean

  has n, :members

  def self.not_admin
    all(:admin => false)
  end

end
