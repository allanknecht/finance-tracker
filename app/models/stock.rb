class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    api_key = Rails.application.credentials.alphavantage_api_key

    price_response = HTTParty.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker_symbol}&apikey=#{api_key}")
    puts "=== GLOBAL_QUOTE response: #{price_response.parsed_response} ==="

    if price_response["Note"] || price_response["Information"]
      return :api_limit
    end

    quote = price_response["Global Quote"]

    return nil if quote.blank?

    sleep(1.5)

    search_response = HTTParty.get("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=#{ticker_symbol}&apikey=#{api_key}")
    puts "=== SYMBOL_SEARCH response: #{search_response.parsed_response} ==="
    matches = search_response["bestMatches"]
    company_name = matches&.first&.dig("2. name") || "N/A"

    begin
      new(ticker: quote["01. symbol"] || ticker_symbol.upcase, name: company_name, last_price: quote["05. price"] || "N/A")
    rescue => exception
      return nil
    end
  end
end
