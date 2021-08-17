class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  #attr_accessible :first_name, :last_name
  # validates :first_name, presence: true
  # validates :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
           
  validates :first_name, :last_name, presence: true
end
