class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def under_stock_limit?
    user_stocks.count < 10
  end

  def stock_already_tracked?(ticker_symbol)
    stocks.where(ticker: ticker_symbol).exists?
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name && last_name
    "Anonymous"
  end

  def search_friends(param)
    return User.none unless param.present?
    User.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?",
               "%#{param}%", "%#{param}%", "%#{param}%")
         .where.not(id: id)
  end
end
