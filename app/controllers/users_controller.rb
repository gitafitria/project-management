class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  has_scope :by_name
  has_scope :by_project

  respond_to :js, :html, :json

  def index
    authorize User

    @users = User.all
  end

  def show
    authorize @user

    today = Date.today
    @projects = Project.where(is_valid: true).where(created_at: today.beginning_of_year..today)
    @invoices = Invoice.where(is_valid: true)

    if @user.client?
      @projects = @projects.where("projects.client_ids @> ARRAY[?]", @user.id)
      @invoices = @invoices.where("project_id IN (?)", @projects.ids)
    end
  end

  def new
    @user = User.new

    authorize @user
  end

  def create
    @user = User.new(user_params)

    authorize @user

    @from_project = params[:from_project]
    @quotation_id = params[:quotation_id]

    if @user.save
      # sign_out(@user)
      # UserMailer.signup_confirmation(@user).deliver
      if quotation_id.present?
        quotation = Quotation.find(quotation_id)
        quotation.update_attribute(:user_id, @user.id)
      end
      @user.send_reset_password_instructions
      if @from_project.present?
        respond_to do |format|
          format.js
        end
      else
        redirect_to user_path(@user)
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end

    end
  end

  def update
    authorize @user

    reject_field = ["password", "password_confirmation"]

    new_params = user_params

    if new_params[:password].blank?
      reject_field.each do |rf|
        new_params = new_params.except(rf.to_sym)
      end
    end

    @user.update(new_params)

    respond_with @user
  end

  def edit
    authorize @user
  end

  def destroy
    authorize @user
    @user.destroy
  end

  def clients
    @clients = apply_scopes(Client).all
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :role,
        :email,
        :password,
        :password_confirmation
      )
    end


end