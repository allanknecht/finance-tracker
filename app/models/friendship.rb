class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :friend_id, uniqueness: { scope: :user_id, message: "already being followed" }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:friend, "can't follow yourself") if user_id == friend_id
  end
end
