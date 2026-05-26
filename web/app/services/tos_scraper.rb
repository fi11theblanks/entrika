class TosScraper

  TOS_URLS = {
    "TikTok" => { url: "https://www.tiktok.com", tos_url: "https://www.tiktok.com/legal/page/us/terms-of-service/en" },
    "Facebook" => { url: "https://www.facebook.com", tos_url: "https://www.facebook.com/legal/terms" },
    "Spotify" => { url: "https://www.spotify.com", tos_url: "https://www.spotify.com/us/legal/end-user-agreement/" },
    "Tinder" => { url: "https://www.tinder.com", tos_url: "https://policies.tinder.com/terms/intl/en" },
    "Shein" => { url: "https://www.shein.com", tos_url: "https://us.shein.com/Terms-and-Conditions-a-281.html" },
    "Roblox" => { url: "https://www.roblox.com", tos_url: "https://en.help.roblox.com/hc/en-us/articles/115004647846" },
    "LinkedIn" => { url: "https://www.linkedin.com", tos_url: "https://www.linkedin.com/legal/user-agreement" },
    "Apple" => { url: "https://www.apple.com", tos_url: "https://www.apple.com/legal/internet-services/terms/site.html" },
    "Wikipedia" => { url: "https://www.wikipedia.org", tos_url: "https://foundation.wikimedia.org/wiki/Policy:Terms_of_Use" },
    "Signal" => { url: "https://www.signal.org", tos_url: "https://signal.org/legal/" },
    "ProtonMail" => { url: "https://proton.me", tos_url: "https://proton.me/legal/terms" },
    "DuckDuckGo" => { url: "https://duckduckgo.com", tos_url: "https://duckduckgo.com/terms" },
    "Mozilla" => { url: "https://www.mozilla.org", tos_url: "https://www.mozilla.org/en-US/about/legal/terms/firefox/" }
  }

  def self.scrape_all
    TOS_URLS.each do |name, data|
      puts "Scraping #{name}..."
      response = HTTParty.get(data[:tos_url], headers: {
        "User-Agent" => "Mozilla/5.0 (compatible; Entrika/1.0)"
      })
      next unless response.success?

      doc = Nokogiri::HTML(response.body)
      doc.css("script, style, nav, header, footer").remove
      text = doc.css("body").text.squish

      company = Company.find_or_create_by(name: name) do |c|
        c.url = data[:url]
      end

      company.update(
        tos_text: text,
        last_checked: Time.current
      )

      puts "✓ #{name} done"
    rescue => e
      puts "✗ #{name} failed: #{e.message}"
    end
  end
end
