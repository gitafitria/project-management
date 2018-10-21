class UserMailer < ApplicationMailer
  default from: "info@gitafitria.com"

  def signup_confirmation(user)
    @user = user

    mail to: user.email, subject: "Sign Up confirmation"
  end
end
