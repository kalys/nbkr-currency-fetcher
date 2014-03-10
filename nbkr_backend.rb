module Nbkr
  module Helpers
    def currency_rates
      doc = Nokogiri::HTML(open("http://www.nbkr.kg/"))
      %w{usd kzt rub eur}.inject({}) do |currency_data, currency_code|
        currency_data[currency_code == 'rub' ? :rur : currency_code.to_sym] = doc.xpath("//td/nobr[contains(.,'#{currency_code.upcase}')]/../../td[3]").first.content
        currency_data
      end
    end
  end

  class Application < Sinatra::Base
    helpers Sinatra::Dalli::Helpers
    set :cache_client, nil
    set :cache_server, "127.0.0.1"
    set :cache_enable, true
    set :cache_logging, true
    set :cache_default_expiry, 86400

    helpers Nbkr::Helpers

    get '/' do
      content_type 'application/json', :charset => 'utf-8'
      cache 'cache', :expiry => 1800 do
        currency_rates.to_json
      end
    end
  end
end

