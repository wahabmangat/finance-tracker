class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  #attr_accessible :first_name, :last_name
  # validates :first_name, presence: true
  # validates :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
           
  validates :first_name, :last_name, presence: true
  def stock_already_tracked?(ticker_sym)
    @stock = Stock.check_db(ticker_sym)
    return false unless @stock
    stocks.where(id: @stock.id).exists?
    #stocks.find_by_id(@stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
     under_stock_limit? && ! stock_already_tracked?(ticker_symbol)
  end
  
  def full_name
    unless first_name.blank? || last_name.blank?
      return "#{first_name} #{last_name}"
    end
    'Anonymous User'
  end
  def self.search(param)
    to_send_back = (matches("email",param) + matches("first_name",param) + matches("last_name",param)).uniq
    return nil unless to_send_back
    to_send_back
  end
  def self.matches(field_name, param)
    where("#{field_name} like ?","%#{param}%")
  end
  def except_current_user(users)
    users.reject { |user| user.id == self.id}
  end
  def not_friends_with?(id_of_user)
    !self.friends.where(id: id_of_user).exists?
  end
end
