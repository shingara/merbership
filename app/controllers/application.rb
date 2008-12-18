class Application < Merb::Controller

protected

  # only if user is admin
  def admin_authenticated
    if session.user
      raise Unauthenticated unless session.user.admin?
    else
      raise Unauthenticated
    end
  end

end
