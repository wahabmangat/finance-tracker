class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  validates :name, :ticker, presence: true
  
  scope :sort_ascend_by_price, -> { order(:last_price) }
  scope :sort_descend_by_price, -> { order(last_price: :desc) }

  
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      #publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      publishable_token: "Tpk_5c6dae0415e34bfebe5d3dc74f450fe2",
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end
   
  
  def self.check_db(ticker_symbol)
    find_by_ticker(ticker_symbol)
  end

  def self.update_price
    client = IEX::Api::Client.new(
            #publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      publishable_token: "Tpk_5c6dae0415e34bfebe5d3dc74f450fe2",
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    all.each do |stock|
      stock.last_price = client.price(stock.ticker)
      stock.save
    end 
  end 
  
  def self.update_all_stocks_price
    all_stocks = Stock.all
    all_stocks.update_price
  end
  # def self.sort_ascend_by_price
  #   order(:last_price)
  # end

  # def self.sort_descend_by_price
  #   order(last_price: :desc)
  # end 

end
