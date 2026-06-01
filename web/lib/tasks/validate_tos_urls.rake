# lib/tasks/validate_tos_urls.rb
namespace :tos do
  task validate: :environment do
    require 'net/http'

    TOS_URLS.each do |company, data|
      [:tos_url, :privacy_url].each do |key|
        url = data[key]
        begin
          uri = URI.parse(url)
          res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: 5, read_timeout: 5) do |http|
            http.head(uri.request_uri)
          end
          status = res.code.to_i
          symbol = status < 400 ? "✓" : "✗"
          puts "#{symbol} #{company} #{key}: #{status}"
        rescue => e
          puts "✗ #{company} #{key}: #{e.message}"
        end
      end
    end
  end
end
