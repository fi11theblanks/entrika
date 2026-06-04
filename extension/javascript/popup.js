// Popup script
chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const baseUrl = "http://127.0.0.1:3000/";
  const baseAPIUrl = "http://127.0.0.1:3000/api/v1/";
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
  const riskAnalysis = document.getElementById("risk-analysis");
  const homepageLink = document.getElementById("homepage-link");
  const manualForm = document.getElementById("manual-form");

  console.log(manualForm);

  fetch(url)
    .then((response) => response.json())
    .then((data) => {
      console.log(data);
      const companyUrl = `${baseAPIUrl}companies/${data.id}/registrations`;
      function displayCompanyInfo() {
        console.log(data);
        riskAnalysis.innerText = data.name;

        analysisCard.classList.remove("text-center");

        makeTruncable(
          document.getElementById("privacy-summary"),
          data.privacy_summary,
        );
        makeTruncable(
          document.getElementById("privacy-analysis"),
          data.privacy_analysis,
        );
        makeTruncable(document.getElementById("tos-summary"), data.tos_summary);
        if (data.risk_label) {
          const hero = document.getElementById("risk-badge");
          const level = data.risk_label.split(" ")[0].toLowerCase();
          const mod = level === "medium" ? "moderate" : level;
          hero.textContent = data.risk_label;
          hero.className = `popup-risk-hero popup-risk-hero--${mod}`;
        }
        companyLink.href = `${baseUrl}companies/${data.id}`;
      }

      function makeTruncable(el, text, limit = 65) {
        const isTruncated = text.length > limit;
        el.innerText = isTruncated ? text.slice(0, limit) + "..." : text;

        if (isTruncated) {
          const toggle = document.createElement("span");
          toggle.innerText = "Show more >>";
          toggle.style.cssText =
            "display:block; text-align:right; cursor:pointer; color:#e0e0e0; font-size:0.8em; margin-top:4px;";
          el.parentElement.appendChild(toggle);

          toggle.addEventListener("click", (event) => {
            const expanded = el.dataset.expanded === "true";
            el.innerText = expanded ? text.slice(0, limit) + "..." : text;
            el.dataset.expanded = expanded ? "false" : "true";
            toggle.innerText = expanded ? "Show more >>" : "<< Show less";
          });
        }
      }

      if (data.error) {
        analysisCard.innerText = "Nothing Here Yet"
        analysisCard.style.paddingTop = "20px";
        tosCard.classList.add("d-none");
        companyLink.classList.add("d-none");
        registrationLink.classList.add("d-none");
        runAnalysis.classList.remove("d-none");

        runAnalysis.addEventListener("click", (event) => {
          const analyzeURL = `${baseAPIUrl}companies/analyze`;
          console.log("Fetching:", analyzeURL);
          analysisCard.classList.remove("d-none");
          analysisCard.innerHTML = `Now analyzing ${currentUrl}<br>
          <i class="fa-solid fa-spinner fa-spin-pulse"></i>`;
          event.preventDefault();
          fetch(analyzeURL, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ url: tabs[0].url }),
          })
            .then((response) => response.json())
            .then((dataOther) => {
              console.log(dataOther);
              if (dataOther.error) {
                console.log(dataOther);
                analysisCard.innerText = "Could not perform analysys";
                analysisCard.style.paddingTop = "20px";
                runAnalysis.classList.add("disabled")
                homepageLink.classList.remove("d-none");
                homepageLink.href = baseUrl;
              } else {
                window.location.reload();
              }
            });
          // .catch((error) => console.error(error));
        });
        // displayCompanyInfo();
      } else if (data.registered) {
        displayCompanyInfo();
        registrationLink.innerText = "Registered ✔";
        registrationLink.classList.add("disabled");
        dashboardLink.classList.remove("d-none");
        dashboardLink.href = `${baseUrl}dashboard`;
      } else {
        displayCompanyInfo();
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
                dashboardLink.href = `${baseUrl}dashboard`;
              }
            })
            .catch((error) => console.error(error));
        });
      }
    })
    .catch((error) => console.error("Error:", error));
});
