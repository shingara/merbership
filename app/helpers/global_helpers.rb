module Merb
  module GlobalHelpers
    def admin?
      if session.user
        return session.user.admin?
      else
        return false
      end
    end
  end
end
