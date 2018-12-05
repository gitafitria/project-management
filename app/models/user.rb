class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: USER_ROLES

  validates :first_name, :last_name, presence: true

  scope :by_name, -> key do
    where("lower(users.first_name) like lower('%#{key}%') or lower(users.last_name) like lower('%#{key}%')")
  end

  scope :by_project, -> project_id do
    project = Project.find(project_id)
    client_ids = project.client_ids

    where("users.id in (?)", client_ids)
  end

  def set_new_password
    # (0...8).map { (65 + rand(26)).chr }.join
    p SecureRandom.hex(10)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
