// Popup script
let currentUrl = "";

chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  currentUrl = new URL(tabs[0].url).hostname;
  console.log(currentUrl);
})

fetch("http://127.0.0.1:3000//api/v1/companies/49")
  .then((response) => response.json())
  .then((data) => {
    document.querySelector(".website-url").innerText = `Now analyzing ${currentUrl}`
    document.querySelector("#risk-analysis").innerText = `Risk analysis for ${data.name}`
    document.querySelector(".privacy-summary").innerText = data.privacy_summary
    document.querySelector(".privacy-analysis").innerText = data.privacy_analysis
    document.querySelector(".tos-summary").innerText = data.tos_summary
  })
  .catch((error) => console.error("Error:", error));
