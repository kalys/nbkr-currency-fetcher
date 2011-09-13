module Nbkr
  class Application < Sinatra::Base
    get '/rates' do
      content_type 'application/json', :charset => 'utf-8'
      currency_rates.to_json
    end
  end
end

def currency_rates
  doc = Nokogiri::HTML(open("http://www.nbkr.kg/"))
  %w{usd kzt rub eur}.inject({}) do |currency_data, currency_code|
    currency_data[currency_code == 'rub' ? :rur : currency_code.to_sym] = doc.xpath("//td/nobr[contains(.,'#{currency_code.upcase}')]/../../td").first.content
    currency_data
  end
end
