class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  respond_to :js, :html
  
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
    # puts error
    # @user.password = @user.set_new_password
    # @user.password_confirmation = @user.set_new_password
    if @user.save
      UserMailer.signup_confirmation(@user).deliver
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    @user.update(user_params)
  end

  def edit
  end

  def destroy
    @user.destroy
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