# Olist_funnel_analysis
# 🇧🇷 Brazilian E-Commerce Funnel Analysis

## End-to-End Data Analytics Project | PostgreSQL + Power BI

An end-to-end data analytics project analyzing the **Olist Brazilian E-Commerce dataset** to understand order progression, fulfillment performance, delivery reliability, customer satisfaction, and repeat purchasing behavior.

The project combines **PostgreSQL data analysis, funnel analysis, customer behavior analysis, and Power BI dashboarding** to translate raw e-commerce data into actionable business insights.

---

## 📌 Business Problem

E-commerce businesses need to understand more than just how many orders they receive.

The key questions addressed in this project are:

- How efficiently do orders progress through the fulfillment lifecycle?
- Where does the largest operational drop-off occur?
- How long does each fulfillment stage take?
- What percentage of orders are delivered on time?
- How does delivery performance relate to customer satisfaction?
- How significant is customer dissatisfaction?
- How strong is customer retention?
- What business opportunities can be identified from the data?

Because the Olist dataset does not contain website visits, browsing sessions, product views, or cart events, a traditional **visitor → cart → checkout → purchase funnel** cannot be measured.

Therefore, this project uses an **Order Lifecycle Funnel**:

> **Order Placed → Approved → Shipped → Delivered → Reviewed**

---

# 🎯 Project Objectives

1. Analyze the end-to-end order lifecycle.
2. Measure conversion and drop-off between funnel stages.
3. Identify operational bottlenecks.
4. Analyze delivery performance and delays.
5. Measure customer satisfaction using review scores.
6. Investigate the relationship between delivery performance and customer satisfaction.
7. Analyze repeat purchasing and customer retention.
8. Develop a recruiter-ready Power BI dashboard.
9. Translate analytical findings into actionable business recommendations.

---

# 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **PostgreSQL** | Data cleaning, transformation, aggregation & analysis |
| **SQL** | Funnel analysis, KPIs, segmentation & business questions |
| **Power BI** | Interactive dashboard & data visualization |
| **DAX** | Dashboard measures and KPIs |
| **Git & GitHub** | Version control & project documentation |
| **Microsoft Word** | Analytical insight report |

---

# 📂 Project Structure

```text
brazilian-ecommerce-funnel-analysis/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_data_profiling.sql
│   ├── 02_customer_analysis.sql
│   ├── 03_order_funnel.sql
│   ├── 04_payment_analysis.sql
│   ├── 05_delivery_analysis.sql
│   ├── 06_review_analysis.sql
│   └── 07_final_funnel_metrics.sql
│
├── dashboard/
│   ├── Brazilian_Ecommerce_Funnel_Dashboard.pbix
│   └── dashboard_preview.png
│
├── report/
│   └── Brazilian_Ecommerce_Funnel_Analysis_Insight_Report.docx
│
├── insights/
│   └── key_findings.md
│
└── screenshots/
    ├── executive_overview.png
    ├── funnel_analysis.png
    └── delivery_customer_satisfaction.png

🎯 Final Takeaway

The analysis reveals a marketplace with strong operational fulfillment but a significant customer-retention opportunity.

The most important finding is the relationship between delivery reliability and customer satisfaction:

Late orders receive substantially lower ratings and are approximately 7× more likely to receive a 1-star review.

At the same time, only 3.12% of customers are repeat buyers.

Therefore, improving delivery reliability and the post-purchase experience represents a potentially important path toward improving customer loyalty and long-term marketplace value.

📬 Contact

Esha Sohail
Data Scientist | Data Analyst
