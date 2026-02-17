class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def my_portfolio
    @tracked_stocks = current_user.stocks
    @user = current_user
  end

  def my_friends
    @friends = current_user.friends
  end

  def search_friends
    if params[:friend].present?
      @friends_found = current_user.except_current_user(User.search(params[:friend]))
      flash.now[:alert] = "No friend found" if @friends_found.empty?
    else
      flash.now[:alert] = "Please enter a name or email to search"
    end
    respond_to do |format|
      format.js { render partial: "friends/result" }
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to my_portfolio_path and return if @user == current_user
    @tracked_stocks = @user.stocks
  end
end
