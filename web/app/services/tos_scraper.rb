require 'uri'

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

  def self.find_tos_url(page_url)
    response = HTTParty.get(page_url, headers: {
      "User-Agent" => "Mozilla/5.0 (compatible; Entrika/1.0)"
    }, timeout: 15)

    return nil unless response.success?

    browser = Ferrum::Browser.new(browser_path: "/usr/bin/brave-browser", timeout: 15, pending_connection_errors: false)
    browser.go_to(page_url)
    doc = Nokogiri::HTML(browser.body)
    browser.quit

   result = { tos_url: nil, privacy_url: nil }

    doc.css("a").each do |link|
      href = link["href"]
      text = link.text.strip.downcase

      next unless href

      if result[:tos_url].nil? && (href.match?(/terms|conditions|policy/i) || text.match?(/terms|conditions|policy/i))
        result[:tos_url] = URI.join(page_url, href).to_s
      end

      if result[:privacy_url].nil? && (href.match?(/privacy|policy/i) || text.match?(/privacy|policy/i))
        result[:privacy_url] = URI.join(page_url, href).to_s
      end

      break if result[:tos_url] && result[:privacy_url]
    end

    result
  end

  def self.scrape_one(page_url, name)

    analysis = CompanyAnalysisData[name]
    data = analysis || TOS_URLS[name] || find_tos_url(page_url)

    # Use pre-written analysis data if available, skip scraping entirely
    if (analysis = CompanyAnalysisData[name])
      puts "Finding #{name} in database..."
      company = Company.find_or_create_by(name: name) do |c|
        uri = URI.parse(page_url)
        c.url = "#{uri.scheme}://#{uri.hostname}"
      end

      company.update(
        tos_url: analysis[:tos_url],
        privacy_url: analysis[:privacy_url],
        tos_summary: analysis[:tos_summary],
        privacy_summary: analysis[:privacy_summary],
        tos_analysis: analysis[:tos_analysis],
        privacy_analysis: analysis[:privacy_analysis],
        risk_score: analysis[:risk_score],
        last_checked: Time.current
      )

      puts "✔ @#{name} done (from analysis data)"
      return company

    end

    #Fall back to TOS_URLS or live scraping
    data = find_tos_url(page_url)

    unless data&.dig(:tos_url).present?
      puts"✖ #{name} failed: could not find url"
      return
    end

    puts "Scraping #{name}..."
    tos_response = HTTParty.get(data[:tos_url], headers: {
      "User-Agent" => "Mozilla/5.0 (compatible; Entrika/1.0)"
      }, timeout: 10, open_timeout: 5)
    return unless tos_response.success?

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
        uri = URI.parse(page_url)
        c.url = "#{uri.scheme}://#{uri.hostname}"
      end

      company.update(
        tos_text: tos_text,
        tos_url: data[:tos_url],
        privacy_text: privacy_text,
        privacy_url: data[:privacy_url],
        last_checked: Time.current
      )

    puts "✓ #{name} done"
    company
  rescue => e
    puts "✗ #{name} failed: #{e.message}"
  end

  # def self.scrape_all
  #   TOS_URLS.each do |name, data|
  #     company = Company.find_by(name: name)
  #     next if company&.tos_url.present?

  #     scrape_one(data[:url], name)
  #   end
  # end
end
