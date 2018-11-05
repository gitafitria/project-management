class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  has_scope :by_name

  respond_to :js, :html, :json

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # sign_out(@user)
      # UserMailer.signup_confirmation(@user).deliver
      @user.send_reset_password_instructions
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    @user.update(user_params)
    respond_with @user
  end

  def edit
  end

  def destroy
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