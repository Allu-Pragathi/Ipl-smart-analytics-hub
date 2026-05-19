# 🏏 IPL Smart Analytics Hub

An end-to-end data analytics project built on **MySQL** and **Power BI**, analyzing 13 seasons of Indian Premier League (IPL) data (2008–2020) with 179,000+ ball-by-ball records.

---

## 📌 Project Overview

This project demonstrates a complete data pipeline:

```
Raw CSV Data  →  MySQL (Schema + ETL + Analytics)  →  Power BI Dashboard
```

**Skills demonstrated:** Database design · ETL · Data cleaning · Advanced SQL (CTEs, Window Functions, Stored Procedures) · Power BI · DAX

---

## 🗂️ Repository Structure

```
ipl-smart-analytics-hub/
│
├── data/
│   └── (Download from Kaggle — link below)
│
├── sql/
│   ├── step1_create_schema.sql       ← Create database and tables
│   ├── step2_load_data.sql           ← Load CSV data
│   ├── step3_data_cleaning.sql       ← Clean and standardize data
│   ├── step4_create_views.sql        ← Analytical views for Power BI
│   └── step5_advanced_analytics.sql  ← CTEs, Window Functions, Rankings
│
├── powerbi/
│   └── IPL_Smart_Analytics_Hub.pbix  ← Power BI dashboard file
│
├── screenshots/
│   ├── dashboard_season_overview.png
│   ├── dashboard_batting.png
│   ├── dashboard_bowling.png
│   └── dashboard_venue.png
│
└── README.md
```

---

## 📊 Dataset

- **Source:** [Kaggle — IPL Complete Dataset 2008–2020](https://www.kaggle.com/datasets/patrickb1912/ipl-complete-dataset-20082020)
- **Files:** `matches.csv` (~756 rows) · `deliveries.csv` (~179,000 rows)

---

## 🛠️ Tech Stack

| Layer | Tool |
|---|---|
| Database | MySQL 8.0 |
| Query Tool | MySQL Workbench |
| Visualization | Power BI Desktop |
| Data Source | Kaggle (IPL 2008–2020) |

---

## ⚙️ How to Run This Project

### Prerequisites
- MySQL 8.0+ installed
- MySQL Workbench installed
- Power BI Desktop installed
- IPL dataset downloaded from Kaggle

### Step-by-step

**1. Run schema script**
```
Open MySQL Workbench → run sql/step1_create_schema.sql
```

**2. Enable local file loading & load data**
```
Run sql/step2_load_data.sql
Update the file paths in LOAD DATA to match your local CSV location
```

**3. Clean and standardize data**
```
Run sql/step3_data_cleaning.sql
```

**4. Create analytical views**
```
Run sql/step4_create_views.sql
```

**5. Run advanced analytics queries**
```
Run sql/step5_advanced_analytics.sql
```

**6. Open Power BI Dashboard**
```
Open powerbi/IPL_Smart_Analytics_Hub.pbix
Reconnect data source to your local MySQL if prompted
```

---

## 📈 Dashboard Pages

| Page | Description |
|---|---|
| Season Overview | Match trends, win methods, team leaderboard |
| Batting Analysis | Top scorers, strike rates, Orange Cap race, fours & sixes |
| Bowling Analysis | Top wicket takers, economy rates, Purple Cap race |
| Team & Venue | Head-to-head, toss analysis, venue heatmap |

---

## 🔍 Key SQL Techniques Used

- **CTEs** — Orange Cap and Purple Cap cumulative race queries
- **Window Functions** — RANK(), SUM() OVER(), PARTITION BY
- **Aggregations** — CASE WHEN for conditional counting
- **Joins** — deliveries ↔ matches for season-level analysis
- **Data Cleaning** — Team name standardization, NULL fixing via UPDATE
- **Views** — 7 analytical views consumed directly by Power BI

---

## 💡 Key Insights from the Data

- Teams winning the toss and choosing to field win ~52% of matches
- Death overs (15–19) produce 35%+ of total runs in an innings
- Mumbai Indians have the highest all-time win percentage among full-season teams
- Wankhede Stadium (Mumbai) is the highest-scoring venue on average

---

## 👤 Author

**[Your Name]**  
[LinkedIn Profile URL]  
[GitHub Profile URL]
