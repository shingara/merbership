class Function
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :nullable => false, :unique => true
  property :admin, Boolean

  has n, :members

  # There are no "cascading" delete in DM-0.9.8
  # it's plan in dm-constraint for futur
  after :destroy do
    Member.all(:function_id.not => Function.all.inject([]) {|h,f| h << f.id}).destroy
  end

  def self.not_admin
    all(:admin => false)
  end

end
