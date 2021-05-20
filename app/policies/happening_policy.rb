class HappeningPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.roles.include?(UserRole.roles[:support_staff])
  end
end
