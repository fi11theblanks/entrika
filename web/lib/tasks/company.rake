namespace :company do
  ANALYSIS_DATA = {
    "TikTok" => {
      risk_score: 3.0,
      tos_summary: "TikTok's Terms of Service explain the rules and conditions for using the platform.",
      privacy_summary: "TikTok's Privacy Policy describes how they collect, use, and protect your personal data.",
      tos_analysis: "The Terms of Service outlines what users agree to when using TikTok.",
      privacy_analysis: "The Privacy Policy describes how TikTok collects and uses personal data."
    },
    "Facebook" => {
      risk_score: 2.0,
      tos_summary: "Facebook's Terms of Service outline the rules for using their platform, the rights users grant to Facebook when sharing content, and the guidelines on what behavior is acceptable. Users agree to only post content they have the right to, and Facebook may use this content within the scope of the platform's functionality. Additionally, the terms describe the limitations on liability and the process for resolving disputes.",
      privacy_summary: "Facebook's Privacy Policy explains how the platform collects, uses, and shares personal data from its users. It discusses the information collected both from user actions and external partners, how it's used to improve services and offer personalized experiences, and the options individuals have to control their data. The policy also clarifies Facebook's stance on sharing data with third parties and outlines user rights, such as accessing or deleting their stored information.",
      tos_analysis: "This document discusses the rights and responsibilities that individuals have when using the company's services. The terms include clauses concerning intellectual property, user obligations, and content ownership. Users should be aware of these terms when posting or sharing.",
      privacy_analysis: "This policy explains how the company collects, uses, and shares user data. It outlines user data collection practices, including what is shared with advertisers or partners, and provides users with information about data control options."
    },
    "Spotify" => {
      risk_score: 2.0,
      tos_summary: "Spotify's Terms of Service set the rules for using their service. By agreeing, you comply with how Spotify manages accounts, content usage, and restrictions like copyright adherence. Failure to abide may lead to account suspension or termination.",
      privacy_summary: "Spotify's Privacy Policy explains how it collects, uses, and shares your data during your use of the service. They gather information such as your preferences and usage to improve and personalize your experience. You have some control over your data, and the policy outlines your rights regarding its usage.",
      tos_analysis: "Spotify reserves the right to modify their offerings and control account usage rules, such as suspending or deleting accounts at their discretion.",
      privacy_analysis: "Spotify collects diverse types of personal data and may share this data with business partners, which requires awareness of how such information might be used or further shared."
    },
    "Tinder" => {
      risk_score: 3.0,
      tos_summary: "The Terms of Service outline the rules for using the app, user responsibilities, acceptable behaviors, how disputes are handled, and the rights of the service.",
      privacy_summary: "The Privacy Policy explains how the app collects, uses, and protects personal information, including user choices regarding their privacy settings and data usage.",
      tos_analysis: "The Terms of Service outline multiple rights and responsibilities both the company and the user have. For example, there are clauses that may affect content ownership and arbitration.",
      privacy_analysis: "The Privacy Policy covers how user data is collected, used, and shared. Key points include what personal data is gathered and under what circumstances it is shared with third parties."
    },
    "Shein" => {
      risk_score: 2.0,
      tos_summary: "Shein's Terms of Service outlines the rules and conditions for accessing and using their website; it covers user account responsibilities, acceptable usage, prohibited activities, and intellectual property rights. The document also addresses dispute resolution, limitations of liability, and the user's agreement to be bound by these conditions by using their site. Lastly, it includes details on how the terms might change and recommends users check for updates regularly.",
      privacy_summary: "Shein's Privacy Policy describes how they collect, use, and protect your personal data. It explains what types of information they gather from you, such as account details and purchase history, alongside how this information is utilized, including processing orders and improving services. Additionally, they provide details on your control over your data and options to manage its use, emphasizing their commitment to secure customer information.",
      tos_analysis: "Analyzed the terms of service to reveal the organization's abilities, clauses of concern, third-party sharing practices, and a concluding privacy advocate's verdict.",
      privacy_analysis: "Examined the privacy policy, assessing company rights, concerning clauses, the extent of third-party data sharing, and providing a privacy advocate's conclusion."
    },
    "Roblox" => {
      risk_score: 2.0,
      tos_summary: "Roblox's Terms of Service outlines the rules and responsibilities users agree to when using the platform. It includes details about acceptable use, user-generated content, intellectual property, and what happens if the rules are violated. By using Roblox, you agree to these terms.",
      privacy_summary: "Roblox's Privacy Policy explains how the platform collects, uses, and protects users' personal information. It covers topics such as data collection while using Roblox, your privacy choices, and how the company ensures data security. This document helps you understand what happens to your data and your rights regarding it.",
      tos_analysis: "Here's a detailed analysis of Roblox's Terms of Service:",
      privacy_analysis: "Here's a thorough overview of Roblox's Privacy Policy:"
    },
    "LinkedIn" => {
      risk_score: 2.0,
      tos_summary: "The LinkedIn Terms of Service outline the rules and conditions for using LinkedIn's platform, including responsibilities like providing accurate information and not engaging in prohibited activities. They describe LinkedIn's rights regarding the content you share, such as licenses to display your public profile information. The document also covers ways you can close your account and limitations of LinkedIn's liability.",
      privacy_summary: "The LinkedIn Privacy Policy explains how the platform collects, uses, and shares your data, such as your profile and activity information. It discusses how this information is used to connect you with professional opportunities and provide relevant ads. The policy also gives details on your rights regarding your data, including managing or deleting your information.",
      tos_analysis: "LinkedIn grants itself a license to use, distribute, and display the content you post on the platform, meaning they can use your updates and articles in ways that promote their service. Users must provide accurate information and maintain professional conduct, which means they can suspend or terminate accounts that do not comply. The arbitration clause limits the user's ability to take part in class action lawsuits, which could limit legal recourse options.",
      privacy_analysis: "LinkedIn collects extensive data including your profile, activity, and device information, meaning they can build a detailed picture of your professional and personal interests. This data is shared with advertisers and third-party partners for targeted advertising. Privacy advocate verdict: LinkedIn's data practices are extensive and warrant careful review of your privacy settings."
    },
    "Apple" => {
      risk_score: 1.0,
      tos_summary: "Apple's Terms of Service explain the rules for using Apple's website and associated services.",
      privacy_summary: "Apple's Privacy Policy describes how they collect, use, and protect personal data given to them by users.",
      tos_analysis: "Apple's Terms of Service outline acceptable use of their services and intellectual property. They can terminate access for violations of these terms. Third-party data sharing is limited and governed by Apple's strict guidelines.",
      privacy_analysis: "Apple collects minimal data necessary to provide their services and has strong privacy protections in place. They do not sell user data to third parties. Privacy advocate verdict: Apple is one of the more privacy-respecting major tech companies."
    },
    "Wikipedia" => {
      risk_score: 1.0,
      tos_summary: "The Terms of Service for Wikimedia describe the foundational rules for using their platforms, like Wikipedia. Users are encouraged to share knowledge freely while agreeing not to engage in malicious activities, copyright violations, or disrupt the services. A collaborative community effort is emphasized, and edits are made under specific licenses for public use.",
      privacy_summary: "The Privacy Policy for Wikimedia outlines how they handle user data to promote transparency. They collect certain personal and usage information to improve the services but take serious measures to protect that data. The policy also highlights that users can edit content without logging in, allowing for enhanced anonymity when desired.",
      tos_analysis: "The Terms of Service outlines the user's rights and responsibilities while using Wikimedia's services.",
      privacy_analysis: "The Privacy Policy explains how Wikimedia collects, uses, and shares personal data, emphasizing transparency and user control."
    },
    "Signal" => {
      risk_score: 1.0,
      tos_summary: "Signal's Terms of Service outline the use of their application, specifying that the service is designed for messaging securely with mutual respect. It makes it clear users are responsible for their account security and usage. Additionally, it details the limitations of Signal's liability and the process for any disputes.",
      privacy_summary: "Signal's Privacy Policy explains their commitment to user privacy, stating that they collect minimal information necessary to provide their secure messaging service. It emphasizes their use of strong encryption and privacy-forward technologies. Signal does not sell user data and operates with transparency regarding interactions with legal requests.",
      tos_analysis: "Signal allows users to utilize their messaging services with strict terms defining acceptable usage. They might reserve rights to restrict usage for malicious activities.",
      privacy_analysis: "Signal demonstrates strong privacy practices by logging minimal metadata and adhering to end-to-end encryption principles, reducing actionable data should third-party sharing occur."
    },
    "ProtonMail" => {
      risk_score: 1.0,
      tos_summary: "Proton's Terms of Service establish the rules and guidelines for using Proton's services. Offers transparency on user rights, prohibited activities, and the handling of accounts. Important to refer to these terms to understand the service agreement between Proton and its users.",
      privacy_summary: "Proton's Privacy Policy explains how the company collects, stores, and uses personal information. Focus is on safeguarding user data, complying with applicable privacy laws, and offering privacy-focused features. Users can review this document to know their privacy rights and options within the Proton services.",
      tos_analysis: "Proton's terms are straightforward — they can suspend accounts that violate acceptable use policies. Services are provided as-is with limited liability.",
      privacy_analysis: "Proton collects minimal data and uses strong encryption. They are based in Switzerland, subject to strict privacy laws. Privacy advocate verdict: one of the most privacy-respecting email services available."
    },
    "DuckDuckGo" => {
      risk_score: 1.0,
      tos_summary: "DuckDuckGo's Terms of Service outline the conditions for using their services.",
      privacy_summary: "DuckDuckGo's Privacy Policy ensures that it collects minimal user information and does not track user searches or browsing habits.",
      tos_analysis: "Analyzing DuckDuckGo's Terms of Service, the document outlines points such as providing services without significant tracking or data sharing. Importantly, this means they respect user privacy while delivering search capabilities. There are few or no concerning provisions that negatively impact user privacy.",
      privacy_analysis: "The Privacy Policy of DuckDuckGo reflects its commitment to not collecting or sharing sensitive personal data. The document reassures users that by not tracking searches, their privacy remains intact."
    },
    "Mozilla" => {
      risk_score: 1.0,
      tos_summary: "The Firefox Terms of Service outline the conditions under which Mozilla offers its web browser and associated services. Users agree to follow the user guidelines and are responsible for their own actions when using Firefox. Mozilla is not liable for damages arising from the use of their services.",
      privacy_summary: "The Firefox Privacy Notice explains how Mozilla collects and uses data when you use their web browser. Data collection is done to improve the service and includes information like usage statistics and system data. Mozilla values user privacy and keeps tracking minimal, giving users control over their data.",
      tos_analysis: "The Terms of Service explain the legal agreement between users and the Mozilla Firefox team. The primary areas to address include ensuring the services' reliability, establishing the user's responsibilities, and outlining the limitations of liability and dispute resolution processes.",
      privacy_analysis: "The Privacy Policy outlines Firefox's practices concerning user data collection, use, and sharing. It details the specific types of information gathered (e.g., telemetry data), the purposes for collecting such data (e.g., product improvement), and emphasizes the commitment to user privacy through minimal data retention and sharing practices."
    }
  }.freeze

  desc "Apply pre-generated AI analysis to all companies (no LLM calls)"
  task seed_analysis: :environment do
    ANALYSIS_DATA.each do |name, data|
      company = Company.find_by(name: name)
      if company
        company.update!(data)
        puts "✓ #{name}"
      else
        puts "✗ #{name} not found"
      end
    end
  end
end
