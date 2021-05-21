class HappeningPolicy < ApplicationPolicy
  # By default, ActionPolicy::Base adds one alias: alias_rule :new?, to: :create?.
  alias_rule :create?, :edit?, :destroy?, to: :update?

  def index?
    true
  end

  def update?
    user.roles.include?(UserRole.roles[:support_staff])
  end

  # show, index ...
  def manage?
    true
  end
end
