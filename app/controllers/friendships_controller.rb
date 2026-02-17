class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    friendship = current_user.friendships.new(friend: friend)
    if friendship.save
      flash[:notice] = "#{friend.full_name} is now being followed"
    else
      flash[:alert] = friendship.errors.full_messages.first
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.find(params[:id])
    flash[:notice] = "#{friendship.friend.full_name} was successfully unfollowed"
    friendship.destroy
    redirect_to my_friends_path
  end
end
