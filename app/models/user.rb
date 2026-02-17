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

  def self.first_name_matches(param)
    where("first_name LIKE ?", "%#{param}%")
  end

  def self.last_name_matches(param)
    where("last_name LIKE ?", "%#{param}%")
  end

  def self.email_matches(param)
    where("email LIKE ?", "%#{param}%")
  end

  def self.search(param)
    return none unless param.present?
    (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
  end

  def except_current_user(users)
    users.reject { |user| user == self }
  end

  def not_friends_with?(user_id)
    !friends.where(id: user_id).exists?
  end
end
