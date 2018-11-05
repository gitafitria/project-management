class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: USER_ROLES

  scope :by_name, -> key do
    where("lower(users.first_name) like lower('%#{key}%') or lower(users.last_name) like lower('%#{key}%')")
  end

  def set_new_password
    # (0...8).map { (65 + rand(26)).chr }.join
    p SecureRandom.hex(10)
  end

end
