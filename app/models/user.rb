class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:vkontakte, :twitter]

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations, dependent: :destroy

  def admin?
    is_a?(Admin)
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def not_author_of?(resource)
    !author_of?(resource)
  end

  def temp_email?
    email =~ /@temp.email/
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization
    email = auth.info.email
    user = User.find_by(email: email)

    unless user
      email ||= "#{Devise.friendly_token[0, 10]}@temp.email"
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
