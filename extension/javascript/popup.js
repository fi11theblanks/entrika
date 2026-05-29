// Popup script
chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const currentUrl = new URL(tabs[0].url).hostname;
  const domain = new URL(tabs[0].url).hostname.replace(/^www\./, "");
  const url = `http://127.0.0.1:3000/api/v1/companies/search?domain=${encodeURIComponent(domain)}`;

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
      const companyUrl = `http://127.0.0.1:3000/api/v1/companies/${data.id}/registrations`;
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
        companyLink.href = `http://127.0.0.1:3000/companies/${data.id}`;
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
          dashboardLink.href = `http://127.0.0.1:3000/dashboard`

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
                dashboardLink.classList.remove("d-none")
              }
            })
            .catch((error) => console.error(error));
        });
      }
    })
    .catch((error) => console.error("Error:", error));
});
