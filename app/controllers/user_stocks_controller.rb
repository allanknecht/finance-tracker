class UserStocksController < ApplicationController
  def create
    unless current_user.can_track_stock?(params[:ticker])
      flash[:alert] = "You can't track this stock."
      redirect_to my_portfolio_path
      return
    end

    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      if stock.nil? || stock == :api_limit
        flash[:alert] = "Could not add stock. Please try again later."
        redirect_to my_portfolio_path
        return
      end
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user: current_user, stock: stock).first
    user_stock.destroy
    flash[:notice] = "Stock #{stock.name} was successfully removed from your portfolio"
    redirect_to my_portfolio_path
  end
end
