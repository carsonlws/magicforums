class UserPolicy < ApplicationPolicy

  def edit?
    user.present? && record == user
  end

  def update?
    edit?
  end
end
