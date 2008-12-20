class MemberMailer < Merb::MailController

  def subscription_soon_outdated
    @setting = Setting.first
    @member = params[:member]
    render_mail
  end

  def subscription_outdated
    @setting = Setting.first
    @member = params[:member]
    render_mail
  end
  
end
