class Setting
  include DataMapper::Resource
  
  property :id, Serial
  property :month_subscription, Integer
  property :month_notification, Integer
  property :field_show, String
  property :field_edit, String


end
