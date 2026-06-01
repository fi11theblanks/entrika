// Popup script
chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const baseUrl = "http://127.0.0.1:3000/"
  const baseAPIUrl = "http://127.0.0.1:3000/api/v1/"
  const currentUrl = new URL(tabs[0].url).hostname;
  const domain = new URL(tabs[0].url).hostname.replace(/^www\./, "");
  const url = `${baseAPIUrl}companies/search?domain=${encodeURIComponent(domain)}`;

  const urlDisplay = document.getElementById("website-url");
  const analysisCard = document.getElementById("analysis-card");
  const tosCard = document.getElementById("tos-card");
  const runAnalysis = document.getElementById("get-analysis");
  const companyLink = document.getElementById("company-link");
  const registrationLink = document.getElementById("registration-link");
  const dashboardLink = document.getElementById("dashboard-link");

  fetch(url)
    .then((response) => response.json())
    .then((data) => {
      console.log(data);
      const companyUrl = `${baseAPIUrl}companies/${data.id}/registrations`;
      function displayCompanyInfo() {
        urlDisplay.innerText =
          `Now analyzing ${currentUrl}`;
        document.getElementById("risk-analysis").innerText =
          `Risk analysis for ${data.name}`;
        document.getElementById("privacy-summary").innerText =
          data.privacy_summary;
        document.getElementById("privacy-analysis").innerText =
          data.privacy_analysis;
        document.getElementById("tos-summary").innerText = data.tos_summary;
        companyLink.href = `${baseUrl}companies/${data.id}`;
        if (data.risk_label) {
          const hero = document.getElementById("risk-badge");
          const level = data.risk_label.split(" ")[0].toLowerCase();
          const mod = level === "medium" ? "moderate" : level;
          hero.textContent = data.risk_label;
          hero.className = `popup-risk-hero popup-risk-hero--${mod}`;
        }
      }

      if (data.error) {
        urlDisplay.innerText = "Company not found";
        analysisCard.classList.add("d-none");
        tosCard.classList.add("d-none");
        companyLink.classList.add("d-none");
        registrationLink.classList.add("d-none");
        runAnalysis.classList.remove("d-none");

        } else if (data.registered) {
          displayCompanyInfo()
          registrationLink.innerText = "Registered ✔";
          registrationLink.classList.add("disabled");
          dashboardLink.classList.remove("d-none");
          dashboardLink.href = `${baseUrl}dashboard`

      } else {
        displayCompanyInfo()
        registrationLink.addEventListener("click", (event) => {
          event.preventDefault();
          fetch(companyUrl, {
            method: "POST",
            // credentials: "include",
            headers: { "Content-Type": "aplication/json" },
            body: JSON.stringify({ company_id: data.id }),
          })
            .then((response) => response.json())
            .then((data) => {
              console.log(data);
              if (data) {
                registrationLink.innerText = "Registered ✔";
                registrationLink.classList.add("disabled");
                dashboardLink.classList.remove("d-none");
                dashboardLink.href = `${baseUrl}dashboard`
              }
            })
            .catch((error) => console.error(error));
        });
      }
    })
    .catch((error) => console.error("Error:", error));
});
