class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    current_user.friends << friend
    flash[:notice] = "#{friend.full_name} was successfully added as a friend"
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.find(params[:id])
    flash[:notice] = "#{friendship.friend.full_name} was successfully removed"
    friendship.destroy
    redirect_to my_friends_path
  end
end
