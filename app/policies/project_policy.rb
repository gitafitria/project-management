class ProjectPolicy < ApplicationPolicy
  def index?
    true if @user.owner? or @user.client?
  end

  def show?
    true if @user.owner? or @user.client?
  end

  def new?
    true if @user.owner?
  end

  def edit?
    true if @user.owner?
  end

  def destroy?
    true if @user.owner?
  end
end