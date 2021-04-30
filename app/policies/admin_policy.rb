class AdminPolicy < ApplicationPolicy
  def translations?
    user.roles.include? UserRole.roles[:support_staff]
  end
end
