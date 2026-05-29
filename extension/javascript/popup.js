// Popup script
chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const currentUrl = new URL(tabs[0].url).hostname;
  const domain = new URL(tabs[0].url).hostname.replace(/^www\./, "");
  const url = `http://127.0.0.1:3000/api/v1/companies/search?domain=${encodeURIComponent(domain)}`;

  const urlDisplay = document.querySelector(".website-url");
  const analysisCard = document.querySelector("#analysis-card");
  const tosCard = document.querySelector("#tos-card");
  const runAnalysis = document.querySelector("#get-analysis");
  const companyLink = document.querySelector("#company-link");
  const registrationLink = document.querySelector("#registration-link");

  fetch(url)
    .then((response) => response.json())
    .then((data) => {
      console.log(data);
      const companyUrl = `http://127.0.0.1:3000/api/v1/companies/${data.id}/registrations`;
      function displayCompanyInfo() {
        document.querySelector(".website-url").innerText =
          `Now analyzing ${currentUrl}`;
        document.querySelector("#risk-analysis").innerText =
          `Risk analysis for ${data.name}`;
        document.querySelector(".privacy-summary").innerText =
          data.privacy_summary;
        document.querySelector(".privacy-analysis").innerText =
          data.privacy_analysis;
        document.querySelector(".tos-summary").innerText = data.tos_summary;
        companyLink.href = `http://127.0.0.1:3000/companies/${data.id}`;
      }

      if (data.error) {
        document.querySelector(".website-url").innerText = "Company not found";
        analysisCard.classList.add("d-none");
        tosCard.classList.add("d-none");
        companyLink.classList.add("d-none");
        registrationLink.classList.add("d-none");
        runAnalysis.classList.remove("d-none");

        } else if (data.registered) {
          displayCompanyInfo()
          registrationLink.innerText = "❌ Unregister";
          // registrationLink.addEventListener("click", (event) => {
          //   event.preventDefault();
          //   fetch(companyUrl), {

          //   }
          // })
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
              }
            })
            .catch((error) => console.error(error));
        });
      }
    })
    .catch((error) => console.error("Error:", error));
});
