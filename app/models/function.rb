class Function
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :nullable => false, :unique => true
  property :admin, Boolean

  has n, :members

end
