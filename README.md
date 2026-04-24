# Healthcare SQL Analysis: Stress & Health Metrics

## Overview
This project analyzes over 30,000 patient records using SQL to identify key factors influencing stress levels and related health outcomes.

The goal is to uncover relationships between lifestyle behaviors and important health indicators such as blood pressure, glucose, BMI, cholesterol, and HbA1c.

---

## Objectives
- Determine whether sleep, smoking, or alcohol has the strongest impact on stress
- Analyze how stress relates to key health metrics (blood pressure, glucose, BMI)
- Evaluate how lifestyle factors influence cholesterol and triglyceride levels
- Explore relationships between lifestyle behaviors and HbA1c levels

---

## Tools Used
- MySQL
- SQL (data cleaning, transformation, and analysis)
- Tableau (data visualization and dashboard creation)

---

## Data Cleaning Process
- Removed irrelevant columns (`random_notes`, `noise_col`)
- Replaced invalid physical activity values with 0
- Handled missing values:
  - Numerical → replaced with averages
  - Categorical → replaced with "Unknown"
- Identified and removed duplicate records
- Applied outlier handling to ensure realistic medical ranges

---

## Key Findings
- Sleep duration had the strongest relationship with stress levels  
- Lower sleep was associated with higher stress  
- Higher stress levels were linked to increased blood pressure  
- Glucose levels increased with stress, but less significantly relative to its range  
- BMI showed minimal variation across stress levels  
- Lifestyle factors had a stronger influence on HbA1c than family history  

---

## Dashboard
A Tableau dashboard was created to visualize the relationship between stress and key health metrics.

![Dashboard Preview](dashboard.png)

---

## File Structure
- `analysis.sql` → Full SQL workflow (data cleaning + analysis)

---

## Key Skills Demonstrated
- Data cleaning and preprocessing in SQL  
- Aggregation and analytical queries  
- Translating raw data into actionable insights  
- Data storytelling through visualization (Tableau)  
