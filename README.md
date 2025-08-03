MTSS Risk Dashboard

📌 Project Overview

The MTSS (Multi-Tiered System of Supports) Risk Dashboard is an interactive Shiny app designed for schools and educators to track student performance, flag at-risk students, and support data-driven intervention planning.

<img width="1875" height="1051" alt="Image" src="https://github.com/user-attachments/assets/42ff9f74-9c4a-4f4f-9747-8616cfa0e446" />



This dashboard takes raw student data (CSV or Google Sheets) and transforms it into visual insights, helping school teams quickly identify students who may need Tier 2 or Tier 3 support.

---

## ✨ Features
- ✅ Dynamic Risk Scoring – Combines attendance, grades, assessments, and behavior indicators.  
- ✅ Color-Coded Tiers – Instantly see which students fall into Tier 1, 2, or 3.  
- ✅ Interactive Filters – Filter by grade, teacher, or individual student.  
- ✅ Data Import Options – Upload a CSV or connect to Google Sheets.  
- ✅ Downloadable Reports – Export student lists and intervention notes.  

---

## ⚙️ How to Run Locally

1️⃣ Download this repo.  
2️⃣ Open `app.R` in RStudio.  
3️⃣ Install required packages (if not already installed):  

```R
install.packages(c("shiny", "tidyverse", "DT", "googlesheets4"))
```

4️⃣ Click Run App in RStudio.  
5️⃣ Upload the sample CSV (included in this repo) or link your own Google Sheet.

---

## 🌐 Deployment
The dashboard can also be deployed online via **[shinyapps.io](https://www.shinyapps.io/)** so educators can access it from any device without installing R.

(Optional: Add your shinyapps.io link here if you want to share a live demo.)

---


## 📂 Repository Contents

- app.R → Full Shiny app code  
- sample_student_data.csv → Anonymized sample dataset (for demo use)  
- README.md → This file  
 

---

## 📈 Next Steps

- 🔄 Add progress monitoring features for long-term tracking.  
- 📊 Include predictive modeling modules (e.g., Bayesian risk scoring).  
- 🎯 Expand to cover early warning indicators for more subjects/grades.

---

## 🛠 Tools Used

- R & Shiny – Core framework for interactivity  
- tidyverse – Data wrangling & visualization  
- DT – Interactive data tables  

---

## 👩‍🏫 Author

Built by Tori Green – Data-driven educator and analyst passionate about turning raw school data into actionable insights for student success.
