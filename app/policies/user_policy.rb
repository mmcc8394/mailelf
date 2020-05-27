class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || itself?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin? || itself?
  end

  def update?
    user.admin? || (itself? && !updating_roles?)
  end

  def edit_password?
    user.admin? || itself?
  end

  def update_password?
    user.admin? || itself?
  end

  def destroy?
    user.admin? && !record.admin?
  end

  private

  def itself?
    user.id == record.id
  end

  def updating_roles?
    user.roles.values.sort != record.roles.values.sort
  end
end