class HappeningPolicy < ApplicationPolicy
  # By default, ActionPolicy::Base adds one alias: alias_rule :new?, to: :create?.
  alias_rule :create?, :edit?, :destroy?, to: :update?

  def index?
    true
  end

  def show?
    true
  end

  def update?
    user.roles.include?(UserRole.roles[:support_staff])
  end

  alias_rule :edit_from_link?, :new_from_link?, to: :update?
end
