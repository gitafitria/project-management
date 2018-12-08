class UserPolicy < ApplicationPolicy
  def index?
    true if @user.owner?
  end

  def show?
    true if @user.owner? or current_user_belonging
  end

  def new?
    true if @user.owner?
  end

  def edit?
    true if @user.owner? or current_user_belonging
  end

  def destroy?
    true if @user.owner?
  end

  def current_user_belonging
    true if (@user.id == @resource.id)
  end
end