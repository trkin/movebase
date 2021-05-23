class VenuePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    user.roles.include?(UserRole.roles[:support_staff])
  end
end
