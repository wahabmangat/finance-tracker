namespace :stock do
  desc "Update last price of all stocks"
  task update_prices_task: :environment do
    Stock.update_all_stocks_price
  end

end
