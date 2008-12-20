class Member
  include DataMapper::Resource
  include Merb::MailerMixin
  
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
  property :notify, Boolean
  property :outdated, Boolean

  belongs_to :function

  before :valid?, :generate_password

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

  def notified?
    subscription_on < Setting.first.month_notification.month.ago.to_date
  end

  def out_subscription?
    subscription_on < Setting.first.month_subscription.month.ago.to_date
  end

  def notify_subscription_if_needed
    @setting = Setting.first
    if out_subscription? && !outdated?
        send_mail(MemberMailer, :subscription_outdated, {
          :from => @setting.email_admin,
          :to => email,
          :subject => "Subscription to #{@setting.name} is soon outdated"
        }, { :member => self})
        self.outdated = true
        save
        return
    elsif notified? && notify?
        send_mail(MemberMailer, :subscription_soon_outdated, {
          :from => @setting.email_admin,
          :to => email,
          :subject => "Subscription to #{@setting.name} is soon outdated"
        }, { :member => self})
        self.notify = true
        save
    elsif notify? && !notified?
      self.notify = false
      save
    elsif outdated? && !out_subscription?
      self.outdated = false
      save
    end
  end

  private

  # Generate a password if no password define. This password if generate by
  # rangexp. A gem require by dm-sweatshop. If password no send after by mail,
  # the password is not getting another time.
  def generate_password
    if new_record?
      self.password = self.password_confirmation = /\w{0,10}/.gen unless password
    end
  end

end
