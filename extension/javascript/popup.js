// Popup script

chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const currentUrl = new URL(tabs[0].url).hostname;
  const domain = new URL(tabs[0].url).hostname.replace(/^www\./, "");
  const url = `http://127.0.0.1:3000/api/v1/companies/search?domain=${encodeURIComponent(domain)}`;

  const urlDisplay = document.querySelector(".website-url");
  const analysisCard = document.querySelector("#analysis-card");
  const tosCard = document.querySelector("#tos-card");

  fetch(url)
    .then((response) => response.json())
    .then((data) => {
      if (data.error) {
        document.querySelector(".website-url").innerText = "Company not found";
        analysisCard.classList.add("d-none");
        tosCard.classList.add("d-none");
      } else {
      document.querySelector(".website-url").innerText =
        `Now analyzing ${currentUrl}`;
      document.querySelector("#risk-analysis").innerText =
        `Risk analysis for ${data.name}`;
      document.querySelector(".privacy-summary").innerText =
        data.privacy_summary;
      document.querySelector(".privacy-analysis").innerText =
        data.privacy_analysis;
      document.querySelector(".tos-summary").innerText = data.tos_summary;
    }})
    .catch((error) => console.error("Error:", error));
});
