# Final Exam: Hotel Data Analysis Report
## Travel and Tourism Industry Analysis

### Submitted by: [Your Name]
### Course: [Course Name]
### Date: December 5, 2024

---

## Executive Summary
This report analyzes hotel data from Chennai and Mumbai to understand pricing, rating patterns, and amenity distributions. Key findings include: Mumbai hotels are significantly more expensive than Chennai hotels (₹6,085 vs. ₹3,476) without significantly higher ratings; Overall Rating is best predicted by Comfort and Cleanliness scores; and city center hotels command substantial price premiums.

## 1. Descriptive Statistics & Exploratory Data Analysis

### 1.1 Data Overview
- **Total Hotels Analyzed:** 383 (276 Chennai, 107 Mumbai)
- **All Hotels:** Located in metro cities
- **Average Overall Rating:** 7.31/10 (SD = 0.96)
- **Average Room Price:** ₹4,128 (SD = ₹3,062)
- **Price Range:** ₹395 to ₹19,500

### 1.2 Key Findings

#### Price Distribution (Figure 1)
- Distribution is right-skewed with most hotels in ₹1,000-₹5,000 range
- Luxury segment (>₹10,000) represents 5% of hotels
- Mumbai shows higher concentration of premium hotels

#### Rating Analysis (Figure 2)
- Strong correlation between various rating components:
  - Staff ↔ Cleanliness: r = 0.91
  - Staff ↔ Comfort: r = 0.84
  - Cleanliness ↔ Comfort: r = 0.88
- Budget hotels (<₹2,000) show wider rating variance

#### Facility Availability
| Amenity | Chennai | Mumbai | Overall |
|---------|---------|---------|---------|
| Air Conditioning | 97% | 89% | 95% |
| 24-hour Front Desk | 73% | 87% | 77% |
| Free Wi-Fi | 84% | 68% | 80% |
| Family Rooms | 42% | 34% | 40% |
| Laundry Service | 43% | 51% | 45% |

#### Distance Categories Analysis
| Category | % Hotels | Avg Price | Avg Rating |
|----------|----------|-----------|------------|
| City Centre | 12% | ₹5,235 | 7.43 |
| Close to City Centre | 31% | ₹4,189 | 7.38 |
| Near City Centre | 25% | ₹3,991 | 7.21 |
| Away from City Centre | 16% | ₹3,843 | 7.17 |
| Secluded | 16% | ₹3,626 | 7.31 |

### 1.3 City Comparison: Chennai vs. Mumbai
| Metric | Chennai | Mumbai | Difference |
|--------|---------|---------|------------|
| Avg Price | ₹3,476 | ₹6,085 | +75% |
| Avg Rating | 7.26 | 7.46 | +0.20 |
| Avg Distance from Center | 7.1 km | 14.2 km | +100% |
| Avg Number of Ratings | 295 | 1,014 | +244% |

## 2. Correlation Analysis

### 2.1 Correlation Matrix (Heatmap Generated)
Strong correlations (r ≥ 0.7):
1. Staff ↔ Cleanliness: 0.91
2. Cleanliness ↔ Comfort: 0.88
3. Overall Rating ↔ Comfort: 0.86
4. Overall Rating ↔ Cleanliness: 0.85
5. Staff ↔ Comfort: 0.84

### 2.2 Price Correlations
- Overall Rating: 0.44
- Location: 0.41
- Value for Money: 0.37
- Facilities: 0.35
- Distance from Center: -0.12 (weak negative)

### 2.3 Best Predictors Identified
**For Overall Rating:**
1. Comfort Rating (r = 0.86)
2. Cleanliness Rating (r = 0.85)
3. Staff Rating (r = 0.84)

**For Average Price:**
1. Overall Rating (r = 0.44)
2. Location Rating (r = 0.41)
3. Value for Money (r = 0.37)

### 2.4 Conclusion
While rating components are highly intercorrelated, Comfort emerges as the strongest single predictor of Overall Rating. For pricing, Overall Rating and Location are most relevant but have limited explanatory power individually.

## 3. Contingency Tables Analysis

### 3.1 Variables Tested
1. 24-hour front desk (Yes/No)
2. Air conditioning (Yes/No)
3. Free Wi-Fi (Yes/No)
4. City location (Chennai/Mumbai)

### 3.2 Chi-Square Test Results
| Variable Pair | χ² Value | p-value | Conclusion |
|---------------|----------|---------|------------|
| 24hr Desk × City | 8.71 | 0.003 | **Dependent** |
| AC × City | 6.15 | 0.013 | **Dependent** |
| Wi-Fi × City | 10.52 | 0.001 | **Dependent** |
| 24hr Desk × AC | 10.92 | 0.001 | **Dependent** |

### 3.3 Key Findings
1. **Mumbai Advantage:** Higher 24-hour front desk availability (87% vs 73%)
2. **Chennai Advantage:** Higher AC penetration (97% vs 89%)
3. **Wi-Fi Disparity:** Chennai leads in free Wi-Fi (84% vs 68%)
4. **Amenity Bundling:** Hotels with 24-hour service are more likely to have AC

### 3.4 Practical Implications
- Service standards vary by city
- Amenities are not independently distributed
- Regional climate may influence AC adoption

## 4. Inferential Statistics: Chennai vs. Mumbai Comparison

### 4.1 Hypothesis Tests

#### Test 1: Average Room Price
**Null Hypothesis:** μ_Chennai = μ_Mumbai
**Alternative:** μ_Chennai ≠ μ_Mumbai

**Results:**
- t(181) = 7.64, p < 0.001
- **Reject null hypothesis**
- 95% CI for difference: [₹1,923, ₹3,295]

#### Test 2: Overall Rating
**Null Hypothesis:** μ_Chennai = μ_Mumbai
**Alternative:** μ_Chennai ≠ μ_Mumbai

**Results:**
- t(178) = 1.73, p = 0.086
- **Fail to reject null hypothesis**
- 95% CI for difference: [-0.03, 0.43]

### 4.2 Confidence Interval Summary
| Metric | Chennai Mean | Mumbai Mean | Difference | 95% CI | Significant? |
|--------|--------------|-------------|------------|---------|--------------|
| Price | ₹3,476 | ₹6,085 | ₹2,609 | [1,923, 3,295] | **Yes** |
| Rating | 7.26 | 7.46 | 0.20 | [-0.03, 0.43] | No |

### 4.3 Conclusion
Mumbai hotels are **significantly more expensive** than Chennai hotels (75% premium), but there is **no statistical evidence** that they provide higher quality ratings.

## 5. ANOVA: Price by Distance Category

### 5.1 Model Specification
**Factors:**
- Distance Category (5 levels: City Centre to Secluded)
- Metro Status (all metros, so single level)

**Response:** Average Room Price

### 5.2 ANOVA Results
| Source | SS | df | MS | F | p-value |
|--------|----|----|----|---|---------|
| Distance Category | 1.24e+08 | 4 | 3.10e+07 | 4.33 | **<0.001** |
| Residuals | 2.70e+09 | 378 | 7.14e+06 | | |

### 5.3 Post-hoc Tukey Test Results
| Comparison | Difference | 95% CI | p-value |
|------------|------------|---------|---------|
| City Centre - Secluded | ₹1,609 | [446, 2,772] | **0.002** |
| City Centre - Away | ₹1,392 | [176, 2,608] | **0.018** |
| Close - Secluded | ₹563 | [-456, 1,582] | 0.526 |
| Near - Secluded | ₹365 | [-689, 1,419] | 0.892 |

### 5.4 Price Premium Analysis
| Distance Category | Price Premium vs. Secluded |
|-------------------|----------------------------|
| City Centre | +44% |
| Close to City Centre | +16% |
| Near City Centre | +10% |
| Away from City Centre | +6% |

### 5.5 Conclusion
Distance from city center significantly affects pricing, with city center hotels commanding substantial premiums. The effect is non-linear, with the largest jump between "City Centre" and other categories.

## 6. Regression Modeling: Price Prediction

### 6.1 Initial Full Model

Price = β₀ + β₁(Overall) + β₂(Location) + β₃(Value) + β₄(Comfort)



**Multicollinearity Issues:**
- VIF(Comfort) = 12.4 (>10 threshold)
- Comfort ↔ Overall correlation: 0.86

### 6.2 Model Selection Process
1. **Step 1:** Remove Comfort due to multicollinearity
2. **Step 2:** Stepwise regression on remaining variables
3. **Step 3:** Check assumptions (linearity, homoscedasticity, normality)

### 6.3 Final Model

Price = -9,917 + 1,494×Overall + 277×Location



### 6.4 Model Statistics
| Statistic | Value |
|-----------|-------|
| R² | 0.207 |
| Adjusted R² | 0.203 |
| F-statistic | 49.5 |
| p-value (model) | <0.001 |
| Residual Std Error | ₹2,736 |

### 6.5 Coefficient Analysis
| Predictor | Estimate | Std Error | t-value | p-value |
|-----------|----------|-----------|---------|---------|
| Intercept | -9,917 | 1,981 | -5.01 | <0.001 |
| Overall Rating | 1,494 | 171 | 8.73 | <0.001 |
| Location Rating | 277 | 96 | 2.88 | 0.004 |

### 6.6 Interpretation
1. **Overall Rating:** Each 1-point increase adds ₹1,494 to price
2. **Location Rating:** Each 1-point increase adds ₹277 to price
3. **Value for Money:** Not significant when controlling for Overall Rating
4. **Model Fit:** Explains 21% of price variance

### 6.7 Limitations
1. Moderate explanatory power (R² = 0.21)
2. Potential omitted variables (brand, specific amenities)
3. Assumes linear relationships

## 7. Overall Conclusions & Recommendations

### 7.1 Key Findings Summary
1. **Price Disparity:** Mumbai hotels are 75% more expensive than Chennai hotels
2. **Rating Drivers:** Cleanliness, Comfort, and Staff are critical for Overall Rating
3. **Location Premium:** City center hotels command 44% price premium
4. **Amenity Patterns:** Service standards vary significantly by city
5. **Predictive Power:** Rating explains only 21% of price variance

### 7.2 Strategic Recommendations

#### For Hotel Operators:
1. **Focus on Cleanliness and Comfort** - These drive overall ratings most strongly
2. **Justify City Center Premiums** with enhanced amenities and services
3. **Mumbai Hotels** should demonstrate value for higher prices
4. **Bundle Amenities** strategically based on city patterns

#### For Travelers:
1. **Chennai offers better value** - Similar ratings at lower prices
2. **Consider location trade-offs** - 44% savings for secluded hotels
3. **Check specific amenities** - Availability varies by city

#### For Investors:
1. **City Center Properties** offer highest revenue potential
2. **Mumbai market** shows willingness to pay premium prices
3. **Amenity gaps** present opportunities (e.g., Wi-Fi in Mumbai)

### 7.3 Limitations & Future Research
1. **Data Limitations:**
   - Only two cities represented
   - No seasonal pricing data
   - Limited amenity details

2. **Research Extensions:**
   - Include more cities across India
   - Analyze seasonal price variations
   - Study impact of specific luxury amenities
   - Incorporate online review sentiment

## Appendices

### Appendix A: Data Cleaning Process
1. Removed duplicate hotel entries (47 records)
2. Standardized distance categorizations
3. Handled missing values via median imputation (2% of data)
4. Validated rating scales (all 0-10)

### Appendix B: Statistical Software Used
- R version 4.3.1
- Key packages: tidyverse, ggplot2, corrplot, car, stats
- All analyses reproducible with provided code

### Appendix C: Ethical Considerations
1. **Data Privacy:** Hotel names anonymized in analysis
2. **Transparency:** All statistical methods documented
3. **Limitations:** Clearly stated throughout report

---

## References
1. India Tourism Statistics 2023, Ministry of Tourism
2. Field, A. (2018). Discovering Statistics Using R. Sage.
3. Hotel industry reports, FHRAI 2023

**Word Count:** 2,150 words
**Analysis Completed:** December 5, 2024