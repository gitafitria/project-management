module UsersHelper
  def fullname(user)
    "#{user.first_name} #{user.last_name}"
  end

  def client_list
    User.where(role: 'client').all
  end
end
