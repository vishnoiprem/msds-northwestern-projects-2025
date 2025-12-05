# Take Home Final Exam - Hotel Data Analysis

**Student:** Prem Vishnoi  
**Course:** 2025FA_MS_DSP_401-DL_SEC61  
**Date:** December 5, 2025  

---

## Overview

This project analyzes hotel data from India's Travel and Tourism Industry, which contributes over **200 billion USD** to India's GDP (2023). The dataset contains information on 3,000+ hotels across various Indian cities.

---

## Dataset Description

The **Hotel Data Set** includes the following variables:

| Variable | Description | Type |
|----------|-------------|------|
| Hotel_ID | Unique identifier for each hotel | Numeric |
| Hotel_Name | Name of the hotel | Character |
| City | City where hotel is located | Character |
| Region | Geographic region (North/South/East/West) | Character |
| Is_Metro | Whether city is a metro (1) or non-metro (0) | Binary |
| Distance_from_City_Center | Distance in kilometers | Numeric |
| Has_Swimming_Pool | Pool availability (0/1) | Binary |
| Has_WiFi | WiFi availability (0/1) | Binary |
| Has_Restaurant | Restaurant availability (0/1) | Binary |
| Has_Gym | Gym availability (0/1) | Binary |
| Has_Spa | Spa availability (0/1) | Binary |
| Has_Parking | Parking availability (0/1) | Binary |
| Star_Rating | Hotel star category (2-5) | Numeric |
| Number_of_Ratings | Total ratings received | Numeric |
| Overall_Rating | Average overall rating (1-5) | Numeric |
| Location_Rating | Location rating (1-5) | Numeric |
| Cleanliness_Rating | Cleanliness rating (1-5) | Numeric |
| Service_Rating | Service rating (1-5) | Numeric |
| Value_for_Money_Rating | Value rating (1-5) | Numeric |
| Comfort_Rating | Comfort rating (1-5) | Numeric |
| Average_Room_Price | Room price in INR | Numeric |

---

## Analysis Questions

### Question 1: Exploratory Data Analysis (EDA)

**Objective:** Understand the dataset through summary statistics and visualizations.

**What we analyze:**
- Distribution of ratings and prices
- Feature availability across hotels
- Differences between metros and non-metros
- Regional and city-wise patterns
- Impact of star ratings

**Key Formulas:**

**Mean:**
```
x̄ = Σxᵢ / n
```

**Standard Deviation:**
```
s = √[Σ(xᵢ - x̄)² / (n-1)]
```

**Skewness:**
```
γ = [n/((n-1)(n-2))] × Σ[(xᵢ - x̄)/s]³
```

---

### Question 2: Correlation Analysis

**Objective:** Find relationships between continuous variables.

**Pearson Correlation Formula:**
```
r = Σ[(xᵢ - x̄)(yᵢ - ȳ)] / √[Σ(xᵢ - x̄)² × Σ(yᵢ - ȳ)²]
```

**Interpretation:**
- r = +1 → Perfect positive correlation
- r = -1 → Perfect negative correlation
- r = 0 → No correlation
- |r| > 0.7 → Strong
- 0.4 < |r| < 0.7 → Moderate
- |r| < 0.4 → Weak

---

### Question 3: Contingency Tables & Chi-Square Tests

**Objective:** Test independence between categorical variables.

**Chi-Square Formula:**
```
χ² = Σ (Observed - Expected)² / Expected
```

**Expected Frequency:**
```
Expected = (Row Total × Column Total) / Grand Total
```

**Degrees of Freedom:**
```
df = (rows - 1) × (columns - 1)
```

**Hypotheses:**
- H₀: Variables are independent
- H₁: Variables are dependent

---

### Question 4: Inferential Statistics (Two-Sample t-Tests)

**Objective:** Compare two cities (Mumbai vs Delhi) for price and ratings.

**Two-Sample t-Test Formula:**
```
t = (x̄₁ - x̄₂) / √(s₁²/n₁ + s₂²/n₂)
```

**95% Confidence Interval:**
```
(x̄₁ - x̄₂) ± t(α/2, df) × √(s₁²/n₁ + s₂²/n₂)
```

**Cohen's d (Effect Size):**
```
d = (x̄₁ - x̄₂) / s_pooled

where s_pooled = √[((n₁-1)s₁² + (n₂-1)s₂²) / (n₁ + n₂ - 2)]
```

**Effect Size Interpretation:**
- |d| < 0.2 → Negligible
- 0.2 ≤ |d| < 0.5 → Small
- 0.5 ≤ |d| < 0.8 → Medium
- |d| ≥ 0.8 → Large

---

### Question 5: ANOVA

**Objective:** Test if Average Room Price depends on Metro status and Distance from city center.

**F-Statistic Formula:**
```
F = MSB / MSW = [SSB/(k-1)] / [SSW/(N-k)]
```

**Two-Way ANOVA Model:**
```
Yᵢⱼₖ = μ + αᵢ + βⱼ + (αβ)ᵢⱼ + εᵢⱼₖ
```

Where:
- μ = overall mean
- αᵢ = effect of Metro status
- βⱼ = effect of Distance category
- (αβ)ᵢⱼ = interaction effect
- εᵢⱼₖ = random error

---

### Question 6: Regression Modeling

**Objective:** Predict Average Room Price using rating variables.

**Multiple Linear Regression:**
```
Y = β₀ + β₁X₁ + β₂X₂ + β₃X₃ + β₄X₄ + ε
```

Where:
- Y = Average Room Price
- X₁ = Overall Rating
- X₂ = Location Rating
- X₃ = Value for Money Rating
- X₄ = Comfort Rating

**R-squared:**
```
R² = 1 - (SSE / SST)
```

**Variance Inflation Factor (VIF):**
```
VIF = 1 / (1 - R²)
```

VIF > 10 indicates serious multicollinearity.

---

## Required R Packages

```r
install.packages(c("readxl", "dplyr", "ggplot2", "corrplot", 
                   "car", "psych", "tidyr", "knitr"))
```

---

## How to Run

1. Place `Hotel Data_Final Exam.xlsx` in your working directory
2. Open `Hotel_Analysis.R` in RStudio
3. Update the file path in line 20 if needed
4. Run the entire script (Ctrl+Shift+Enter)
5. Check the output in console and Plots pane

---

## Output Files

The script generates:
- Summary statistics tables
- Distribution plots
- Correlation heatmap
- Box plots for comparisons
- ANOVA interaction plots
- Regression diagnostic plots

---

## Key Findings Summary

1. **EDA:** Metro hotels have ~₹800 higher prices; Swimming Pool has biggest rating impact
2. **Correlation:** Comfort Rating best predicts Overall Rating (r=0.89); Star Rating best predicts Price (r=0.85)
3. **Chi-Square:** Swimming Pool is significantly associated with high ratings
4. **t-Tests:** No significant price/rating difference between Mumbai and Delhi
5. **ANOVA:** Metro status significantly affects price; Distance does not
6. **Regression:** Overall Rating alone explains ~24% of price variation

---

## Contact

**Student:** Prem Vishnoi  
**Course:** 2025FA_MS_DSP_401-DL_SEC61

---

*End of README*
