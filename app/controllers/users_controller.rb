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
    @tracked_stocks=@user.stocks.update_price
    respond_to do |format|
     flash.now[:notice] = "Stock prices updated"
     format.html
     format.js { render partial: 'users/shared/stocks_list' }
    end
  end
  
  def sort_price
    @user = User.where(id: params[:id]).first
    tracked_stocks =@user.stocks
    if params[:ch].to_i == 1
      @tracked_stocks = tracked_stocks.sort_ascend_by_price
    elsif params[:ch].to_i == 0
      @tracked_stocks = tracked_stocks.sort_descend_by_price
    end

    respond_to do |format|
      flash.now[:notice] = "Stock prices sorted"
      format.html
      format.js { render partial: 'users/shared/stocks_list' }
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
