class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks 
  end
  def my_friends
    @my_friends = current_user.friends
  end
  def update_price
    @user = User.where(id: params[:id]).first
    @tracked_stocks =@user.stocks
    Stock.update_price(@tracked_stocks)
    # respond_to do |format|
    #  flash.now[:notice] = "Stock prices updated"
    #  format.js {render partial: '/shared/stocks_list'}
    # end
    if @user == current_user
      render "my_portfolio" and return
    else 
      render "show" and return
    end
  end
  def sort_price
    @user = User.where(id: params[:id]).first
    @tracked_stocks =@user.stocks
    if params[:ch] == 1
      @tracked_stocks.sort_by! { |stk| stk.last_price }
      @tracked_stocks.sort_by(&:last_price)   #=> [...sorted array...]
    elsif params[:ch] == 0
      @tracked_stocks.sort_by! { |stk| stk.last_price }.reverse
    end
    if @user == current_user
      render "my_portfolio" and return
    else 
      render "show" and return
    end
  end
  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
  def search
    if params[:q].values.reject(&:blank?).any?
      @q = User.ransack(params[:q])
      @friend =@q.result(distinct: true)
      @friend = current_user.except_current_user(@friend)
      unless @friend.empty?
        respond_to do |format|
					flash.now[:notice] = "Friend information found"
					format.js { render  partial: 'users/friend_result'}
				end
			else
				respond_to do |format|
				  flash.now[:alert] = "Couldn't find user."
					format.js { render  partial: 'users/friend_result'}
				end
			end
		else 
			respond_to do |format|
				flash.now[:alert] = "Please enter the name or email to search"
				format.js { render  partial: 'users/friend_result'}
			end
		end
  end
end
