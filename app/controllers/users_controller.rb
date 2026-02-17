class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search_friends
    if params[:friend].present?
      @friend = current_user.search_friends(params[:friend]).first
      flash.now[:alert] = "No friend found" unless @friend
    else
      flash.now[:alert] = "Please enter a name or email to search"
    end
    respond_to do |format|
      format.js { render partial: "friends/result" }
    end
  end
end
