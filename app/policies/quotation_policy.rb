class QuotationPolicy < ApplicationPolicy
  def index?
    true if @user.owner? or @user.client?
  end

  def show?
    true if @user.owner? or @user.client?
  end

  def new?
    true
  end

  def edit?
    true if @user.owner? or @user.client?
  end

  def destroy?
    true if @user.owner?
  end

  def pdf?
    export?
  end

  def export_email?
    export?
  end

  def export?
    true if @user.owner? or @user.client?
  end

end