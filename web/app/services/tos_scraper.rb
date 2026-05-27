class TosScraper

  TOS_URLS = {
    "TikTok" => { url: "https://www.tiktok.com", tos_url: "https://www.tiktok.com/legal/page/us/terms-of-service/en", privacy_url: "https://www.tiktok.com/legal/page/us/privacy-policy/en" },
    "Facebook" => { url: "https://www.facebook.com", tos_url: "https://www.facebook.com/legal/terms", privacy_url: "https://www.facebook.com/privacy/policy" },
    "Spotify" => { url: "https://www.spotify.com", tos_url: "https://www.spotify.com/us/legal/end-user-agreement/", privacy_url: "https://www.spotify.com/us/legal/privacy-policy/" },
    "Tinder" => { url: "https://www.tinder.com", tos_url: "https://policies.tinder.com/terms/intl/en", privacy_url: "https://policies.tinder.com/privacy/intl/en" },
    "Shein" => { url: "https://www.shein.com", tos_url: "https://us.shein.com/Terms-and-Conditions-a-281.html", privacy_url: "https://us.shein.com/Privacy-Security-Policy-a-282.html" },
    "Roblox" => { url: "https://www.roblox.com", tos_url: "https://en.help.roblox.com/hc/en-us/articles/115004647846", privacy_url: "https://en.help.roblox.com/hc/en-us/articles/115004630823" },
    "LinkedIn" => { url: "https://www.linkedin.com", tos_url: "https://www.linkedin.com/legal/user-agreement", privacy_url: "https://www.linkedin.com/legal/privacy-policy" },
    "Apple" => { url: "https://www.apple.com", tos_url: "https://www.apple.com/legal/internet-services/terms/site.html", privacy_url: "https://www.apple.com/legal/privacy/" },
    "Wikipedia" => { url: "https://www.wikipedia.org", tos_url: "https://foundation.wikimedia.org/wiki/Policy:Terms_of_Use", privacy_url: "https://foundation.wikimedia.org/wiki/Policy:Privacy_policy" },
    "Signal" => { url: "https://www.signal.org", tos_url: "https://signal.org/legal/", privacy_url: "https://signal.org/legal/" },
    "ProtonMail" => { url: "https://proton.me", tos_url: "https://proton.me/legal/terms", privacy_url: "https://proton.me/legal/privacy" },
    "DuckDuckGo" => { url: "https://duckduckgo.com", tos_url: "https://duckduckgo.com/terms", privacy_url: "https://duckduckgo.com/privacy" },
    "Mozilla" => { url: "https://www.mozilla.org", tos_url: "https://www.mozilla.org/en-US/about/legal/terms/firefox/", privacy_url: "https://www.mozilla.org/en-US/privacy/firefox/" }
  }

  def self.scrape_all
    TOS_URLS.each do |name, data|
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
