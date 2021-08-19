class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks 
  end
  def my_friends
    @my_friends = current_user.friends
  end
  def show
    @user = User.find(params[:id])
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
