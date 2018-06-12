class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:add_email, :signup_email]
  before_action :email_verify, only: [:add_email, :signup_email]
  skip_before_action :ensure_signup_complete, only: [:add_email, :signup_email]

  def add_email
  end

  def signup_email
    if current_user.update(user_params)
      redirect_to add_email_user_path(current_user), notice: 'Confirm your mail (check email)'
    else
      render :add_email
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def email_verify
    unless current_user.temp_email?
      redirect_to root_path, notice: 'You do not need to install уmail'
    end
  end
end
