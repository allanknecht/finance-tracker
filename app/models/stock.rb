class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    api_key = Rails.application.credentials.alphavantage_api_key
    response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{api_key}")
    quote = response["Global Quote"]

    return nil if quote.blank?

    new(ticker: quote["01. symbol"], last_price: quote["05. price"])
  end
end
