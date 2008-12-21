class Setting
  include DataMapper::Resource
  
  property :id, Serial
  property :month_subscription, Integer
  property :month_notification, Integer
  property :field_show, Yaml, :default => {}
  property :field_edit, Yaml, :default => {}
  property :name, String
  property :email_admin, String, :format => :email_address

  def completed?
    !month_subscription.blank? && !month_notification.blank? && !name.blank? && !email_admin.blank?
  end


end
