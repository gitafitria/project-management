class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum role: USER_ROLES

  def set_new_password
    # (0...8).map { (65 + rand(26)).chr }.join
    p SecureRandom.hex(10)
  end
  
end
