class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  has_many :comments

  def author_of?(resource)
    resource.user_id == id
  end

  def not_author_of?(resource)
    !author_of?(resource)
  end
end
