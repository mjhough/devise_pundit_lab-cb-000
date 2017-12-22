class NotePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.moderator? || user.admin?
  end

  def show?
    user.moderator? || user.admin? || record.user == user || record.visible_to.include?(user.name)
  end

  def edit?
    user.admin? || record.user == user
  end

  def destroy?
    user.admin? || record.user == user
  end
end