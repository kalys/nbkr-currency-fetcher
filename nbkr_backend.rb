class NbkrBackendApp < Sinatra::Base
  get '/rates' do
    content_type 'application/json', :charset => 'utf-8'
    currency_rates.to_json
  end

end

def currency_rates
  currency_data = {}
  doc = Nokogiri::HTML(open("http://www.nbkr.kg/"))
  %w{usd kzt rub eur}.each do |currency_nbkr_code|
    currency_data[currency_nbkr_code.to_sym] = doc.xpath("//td/nobr[contains(.,'#{currency_nbkr_code.upcase}')]/../../td").first.content
  end
  currency_data[:rur] = currency_data.delete :rub
  currency_data
end
