require_relative "../../lib/company_analysis_data"

class TosScraper
  def self.scrape_all
    CompanyAnalysisData.each do |name, data|
      puts "Scraping #{name}..."
      tos_response = HTTParty.get(data[:tos_url], headers: {
        "User-Agent" => "Mozilla/5.0 (compatible; Entrika/1.0)"
      }, timeout: 10, open_timeout: 5)
      next unless tos_response.success?

      tos_doc = Nokogiri::HTML(tos_response.body)
      tos_doc.css("script, style, nav, header, footer").remove
      tos_text = tos_doc.css("body").text.squish

      privacy_text = nil
      if data[:privacy_url] && data[:privacy_url] != data[:tos_url]
        privacy_response = HTTParty.get(data[:privacy_url], headers: {
          "User-Agent" => "Mozilla/5.0 (compatible; Entrika/1.0)"
        }, timeout: 10, open_timeout: 5)
        if privacy_response.success?
          privacy_doc = Nokogiri::HTML(privacy_response.body)
          privacy_doc.css("script, style, nav, header, footer").remove
          privacy_text = privacy_doc.css("body").text.squish
        end
      end

      company = Company.find_or_create_by(name: name) do |c|
        c.url = data[:url]
      end

      company.update(
        tos_text: tos_text,
        tos_url: data[:tos_url],
        privacy_text: privacy_text,
        privacy_url: data[:privacy_url],
        last_checked: Time.current
      )

      puts "✓ #{name} done"
    rescue => e
      puts "✗ #{name} failed: #{e.message}"
    end
  end
end
