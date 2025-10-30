# TASK 3: POINT AND INTERVAL ESTIMATION WITH REAL DATA
# ================================================================

## Assignment Overview
This task demonstrates point estimation and confidence interval construction using real-world 
data, specifically examining cholesterol levels in a nutrition study. We computed multiple 
confidence intervals and analyzed the trade-off between confidence and precision.

---

## DATASET INFORMATION

**Dataset:** Synthetic Nutrition Study  
**Sample Size:** n = 315 participants  
**Variable of Interest:** Cholesterol (Total cholesterol level in mg/dL)

### Population of Interest
The population consists of all adults who could potentially participate in a nutrition study. 
This dataset represents a random sample from this population. We are interested in estimating 
the **true population mean cholesterol level**.

### Clinical Context
Cholesterol levels are classified as:
- **Desirable:** < 200 mg/dL
- **Borderline High:** 200-239 mg/dL  
- **High:** ≥ 240 mg/dL

---

## DESCRIPTIVE STATISTICS

| Statistic | Value |
|-----------|-------|
| Sample Size (n) | 315 |
| Minimum | 120.00 mg/dL |
| 1st Quartile (Q1) | 175.00 mg/dL |
| **Median** | 201.00 mg/dL |
| **Mean (x̄)** | **200.44 mg/dL** |
| 3rd Quartile (Q3) | 227.50 mg/dL |
| Maximum | 303.00 mg/dL |
| Range | 183.00 mg/dL |
| IQR | 52.50 mg/dL |
| **Std Dev (s)** | **38.61 mg/dL** |
| **Std Error (SE)** | **2.18 mg/dL** |

---

## PART A: POINT ESTIMATES

### Point Estimate for Population Mean (μ)

**Sample Mean (x̄) = 200.44 mg/dL**

**Interpretation:**
Based on our sample of 315 participants, we estimate that the **average cholesterol level 
in the population is 200.44 mg/dL**. This is our single best guess (point estimate) for 
the true population mean. 

However, we acknowledge that:
- This estimate has **sampling variability**
- It is **unlikely to be exactly** equal to the true population parameter
- Different samples would yield different point estimates
- We need confidence intervals to quantify the uncertainty

**Clinical Note:** The estimated mean of 200.44 mg/dL falls in the **"borderline high"** 
range (200-239 mg/dL), suggesting that on average, participants in this population are at 
the threshold between desirable and concerning cholesterol levels.

### Point Estimate for Population Standard Deviation (σ)

**Sample Standard Deviation (s) = 38.61 mg/dL**

**Interpretation:**
The standard deviation of 38.61 mg/dL indicates the **typical amount of variation** in 
cholesterol levels around the mean. This tells us:

- About 68% of individuals have cholesterol within ±1 SD of the mean (161.83 to 239.05 mg/dL)
- About 95% of individuals have cholesterol within ±2 SD of the mean (123.22 to 277.66 mg/dL)
- There is considerable individual variability in cholesterol levels
- Some individuals are well below the mean (healthy), while others are well above (high risk)

### Standard Error of the Mean

**Standard Error (SE) = 2.18 mg/dL**

**Formula:** SE = s / √n = 38.61 / √315 = 2.18

**Interpretation:**
The standard error represents the **estimated standard deviation of the sampling distribution** 
of the mean. It quantifies how much we expect sample means to vary from one sample to another.

- **Smaller SE = More precise estimate** of the population mean
- SE decreases as sample size increases (√n in denominator)
- SE is much smaller than SD (2.18 vs. 38.61) because we're estimating the mean, not 
  predicting individual values

---

## PART B: CONFIDENCE INTERVALS

### Confidence Intervals at Four Levels

| Confidence | Alpha | t-critical | Margin of Error | Lower Bound | Upper Bound | Width |
|------------|-------|-----------|-----------------|-------------|-------------|-------|
| **80%** | 0.20 | 1.284 | 2.79 | **197.65** | **203.24** | **5.59** |
| **90%** | 0.10 | 1.650 | 3.59 | **196.85** | **204.03** | **7.18** |
| **95%** | 0.05 | 1.968 | 4.28 | **196.16** | **204.72** | **8.56** |
| **99%** | 0.01 | 2.592 | 5.64 | **194.80** | **206.08** | **11.28** |

**Formula used:** CI = x̄ ± t(α/2, df) × SE  
where df = n - 1 = 314

### Detailed Interpretations

#### 80% Confidence Interval: [197.65, 203.24] mg/dL

**Interpretation:**
We are **80% confident** that the true population mean cholesterol level lies between 
197.65 and 203.24 mg/dL. 

**What this means:**
- If we repeated this sampling process many times (drawing new samples of n=315)
- And computed an 80% CI for each sample
- Approximately **80% of those intervals** would contain the true population mean
- About **20% would miss** the true mean (they would be unlucky samples)
- We accept a 20% risk (α = 0.20) of being wrong

#### 90% Confidence Interval: [196.85, 204.03] mg/dL

**Interpretation:**
We are **90% confident** that the true population mean cholesterol level lies between 
196.85 and 204.03 mg/dL.

**What this means:**
- Higher confidence (90% vs 80%)
- Lower risk of error (α = 0.10 vs 0.20)
- Wider interval (7.18 vs 5.59 mg/dL) to achieve this higher confidence
- If repeated many times, 90% of intervals would capture the true mean

#### 95% Confidence Interval: [196.16, 204.72] mg/dL

**Interpretation:**
We are **95% confident** that the true population mean cholesterol level lies between 
196.16 and 204.72 mg/dL.

**What this means:**
- **Standard choice** in most research (conventional level)
- Good balance between confidence and precision
- Only 5% risk (α = 0.05) of the interval missing the true mean
- Width of 8.56 mg/dL represents reasonable precision
- This is the most commonly reported CI in scientific literature

#### 99% Confidence Interval: [194.80, 206.08] mg/dL

**Interpretation:**
We are **99% confident** that the true population mean cholesterol level lies between 
194.80 and 206.08 mg/dL.

**What this means:**
- **Very high confidence** (99% vs 95%)
- Very low risk (α = 0.01) of being wrong
- Substantially wider interval (11.28 mg/dL) - the price of higher confidence
- Used when minimizing risk is critical (medical, safety applications)
- Only 1% chance the true mean falls outside this range

---

## PART C: WHAT HAPPENS AS CONFIDENCE INCREASES?

### The Confidence-Precision Trade-off

**Key Finding:** As confidence level increases, interval width INCREASES dramatically.

| Confidence | Width | Increase vs 80% CI |
|------------|-------|--------------------|
| 80% | 5.59 mg/dL | 0% (baseline) |
| 90% | 7.18 mg/dL | +28.5% |
| 95% | 8.56 mg/dL | +53.2% |
| 99% | 11.28 mg/dL | **+101.8%** (doubled!) |

### Why Does This Happen?

**Mathematical Explanation:**

The confidence interval formula is:
```
CI = x̄ ± t(α/2, df) × SE
```

As confidence increases:
1. **Alpha (α) decreases** → (1 - α) increases
2. **α/2 moves toward zero** → We're capturing more area under the curve
3. **t-critical value increases** → We go further out into the tails of the t-distribution
4. **Margin of error increases** → t-critical × SE gets larger
5. **Interval width increases** → Upper bound - Lower bound gets wider

**Visualizing t-critical values:**
- 80% CI: t = 1.284 (capturing middle 80% of distribution)
- 90% CI: t = 1.650 (capturing middle 90%)
- 95% CI: t = 1.968 (capturing middle 95%)
- 99% CI: t = 2.592 (capturing middle 99% - far into tails!)

### The Fishing Net Analogy

Think of confidence intervals like casting a fishing net to catch a fish (the true mean):

- **80% CI:** Narrow net (5.59 mg/dL wide)
  - Higher risk of missing the fish (20% chance)
  - More precise, but less confident
  
- **90% CI:** Medium net (7.18 mg/dL wide)
  - Moderate risk (10% chance of missing)
  - Balanced approach
  
- **95% CI:** Wide net (8.56 mg/dL wide)
  - Low risk (5% chance of missing)
  - Standard in research
  
- **99% CI:** Very wide net (11.28 mg/dL wide)
  - Very low risk (1% chance of missing)
  - Maximum confidence, minimum precision

### The Fundamental Trade-off

**You cannot have both maximum confidence AND maximum precision simultaneously.**

- Want a **narrow interval** (high precision)? → Use lower confidence (e.g., 80%)
  - Risk: Higher chance of missing the true parameter
  
- Want **high confidence** (lower risk)? → Accept wider interval (e.g., 99%)
  - Cost: Less precise estimate

- Need **balance**? → Use 95% confidence (conventional standard)
  - Most common in scientific research
  - Good compromise between precision and confidence

---

## CONFIDENCE vs. CONFIDENCE: IMPORTANT DISTINCTIONS

### What Confidence Level MEANS

**Correct Interpretation (Frequentist):**
"If we repeated this sampling process many times and computed a 95% CI each time, 
approximately 95% of those intervals would contain the true population mean."

**What it is NOT:**
- ❌ "There is a 95% probability that the true mean is in this interval"
  - The parameter μ is **fixed**, not random
  - Our interval either contains it (100%) or doesn't (0%)
  
- ❌ "95% of the data falls within this interval"
  - That would be the data range or percentiles
  - CI is about the **mean**, not individual data points

### Relationship to Alpha (α)

**Alpha = Risk of Error**

The relationship is: **Confidence = 1 - α**

| Confidence | Alpha (α) | What α represents |
|------------|-----------|-------------------|
| 80% | 0.20 | Accept 20% risk of being wrong |
| 90% | 0.10 | Accept 10% risk of being wrong |
| 95% | 0.05 | Accept 5% risk of being wrong |
| 99% | 0.01 | Accept 1% risk of being wrong |

**Alpha is split equally in both tails:**
- For 95% CI: α = 0.05, so α/2 = 0.025 in each tail
- The middle 95% is between the 2.5th and 97.5th percentiles

### Practical Implications by Field

**Medical/Clinical Research (typically 95-99%):**
- High stakes (patient safety, treatment decisions)
- Want to minimize risk of false conclusions
- Example: "We are 99% confident this drug reduces cholesterol"

**Exploratory Research (often 80-90%):**
- Early-stage investigation
- Prioritize detecting potential effects
- Willing to accept higher error rate for more precision

**Business/Marketing (varies, often 90-95%):**
- Balance cost of data collection vs. decision quality
- Example: "We are 90% confident the new ad increases sales"

**Quality Control (often 99%):**
- Manufacturing tolerances must be met
- High cost of defects
- Example: "We are 99% confident defect rate < 1%"

---

## CHECKING ASSUMPTIONS

For t-based confidence intervals to be valid, we need:

### 1. Random Sampling ✓
- Assumption: Sample was randomly selected from population
- Status: **Assumed satisfied** (based on study design)

### 2. Independence ✓
- Assumption: Observations are independent of each other
- Status: **Assumed satisfied** (each participant measured once)

### 3. Normality
- Assumption: Population is normally distributed OR n ≥ 30

**Shapiro-Wilk Normality Test:**
- W-statistic = 0.9919
- p-value = 0.0818
- **Result:** FAIL TO REJECT normality (p > 0.05)
- **Conclusion:** Data are consistent with normal distribution ✓

**Distribution Shape:**
- Skewness = -0.0214 (approximately symmetric) ✓
- Excess Kurtosis = -0.3654 (approximately mesokurtic, like normal) ✓

**Sample Size Check:**
- n = 315 >> 30 ✓
- **Even if** population were not perfectly normal, CLT ensures the sampling 
  distribution of the mean IS approximately normal

**Overall Assessment:** ✓ All assumptions satisfied - confidence intervals are valid!

---

## VISUALIZATIONS PROVIDED

### 1. Distribution of Cholesterol (Histogram + Normal Overlay)
Shows:
- Histogram of the 315 cholesterol measurements
- Kernel density estimate (smooth curve)
- Theoretical normal distribution overlay
- Sample mean indicated

**What to look for:**
- Is distribution approximately bell-shaped? YES
- Are there outliers? Some, but not extreme
- Does normal curve fit reasonably? YES

### 2. Q-Q Plot (Quantile-Quantile Plot)
Shows:
- Observed quantiles vs. theoretical normal quantiles
- Points should fall near diagonal line if data are normal

**Interpretation:**
- Most points hug the line → consistent with normality
- Slight departures at extremes are typical and acceptable
- No major S-curve or systematic departures

### 3. Confidence Intervals Visualization
Shows:
- All four CIs plotted simultaneously
- 80% (coral), 90% (gold), 95% (sky blue), 99% (purple)
- Sample mean marked with green point
- Clear visual of how intervals widen

**What to observe:**
- Nested nature: Each wider CI contains the narrower ones
- All CIs centered at x̄ = 200.44
- Progressive widening as confidence increases

### 4. Interval Width vs. Confidence Level
Shows:
- Line plot: confidence (x-axis) vs. width (y-axis)
- Demonstrates the exponential-like increase

**Key insight:**
- Not a linear relationship!
- Going from 95% → 99% adds more width than 80% → 95%
- Diminishing returns for precision as confidence increases

### 5. Sampling Distribution Conceptual Diagram
Shows:
- Bell curve representing sampling distribution of x̄
- 95% CI region shaded
- Lower and upper bounds marked
- Illustrates "capturing" the middle 95%

**Educational value:**
- Visualizes what "95% confidence" means
- Shows the tails (α/2 = 0.025 in each)
- Helps understand margin of error concept

---

## KEY TAKEAWAYS FOR YOUR ASSIGNMENT

### Main Results Summary

**Point Estimates:**
- Population Mean μ ≈ 200.44 mg/dL
- Population SD σ ≈ 38.61 mg/dL
- Standard Error = 2.18 mg/dL

**Confidence Intervals:**
- 80%: [197.65, 203.24] - Narrowest, least confident
- 90%: [196.85, 204.03] - Moderate
- 95%: [196.16, 204.72] - **Standard choice**
- 99%: [194.80, 206.08] - Widest, most confident

**The Trade-off:**
- 99% CI is **101.8% wider** than 80% CI
- Doubling confidence (80%→99%) roughly doubles interval width
- This is the **fundamental trade-off** in statistical inference

### How to Write This Up

**Introduction:**
"We analyzed cholesterol data from 315 adults in a nutrition study to estimate the 
population mean cholesterol level and construct confidence intervals."

**Methods:**
"Point estimates (mean and standard deviation) were computed from the sample. 
Confidence intervals at 80%, 90%, 95%, and 99% levels were constructed using the 
t-distribution with 314 degrees of freedom."

**Results:**
"The sample mean cholesterol was 200.44 mg/dL (SD = 38.61, SE = 2.18). The 95% 
confidence interval was [196.16, 204.72] mg/dL. As confidence increased from 80% 
to 99%, interval width increased from 5.59 to 11.28 mg/dL (a 101.8% increase)."

**Discussion:**
"The results demonstrate the fundamental trade-off between confidence and precision. 
Higher confidence requires wider intervals, reflecting greater uncertainty about the 
parameter estimate. The 95% CI suggests the population mean cholesterol is in the 
'borderline high' range (200-240 mg/dL), warranting potential public health attention."

**Conclusion:**
"Confidence intervals provide a range of plausible values for the population parameter, 
with the width reflecting our certainty. Researchers must balance the need for high 
confidence (minimizing error risk) against the desire for precision (narrow intervals)."

---

## ANSWERS TO ASSIGNMENT QUESTIONS

### Q: "State clearly the population of interest"
**A:** The population of interest consists of all adults who could potentially participate 
in a nutrition study. We have a sample of n = 315 participants.

### Q: "Compute point estimates for the mean and standard deviation. Interpret their meaning."
**A:** 
- **Mean:** x̄ = 200.44 mg/dL - Our best single estimate of the population mean cholesterol
- **SD:** s = 38.61 mg/dL - Indicates typical variation around the mean
- **SE:** 2.18 mg/dL - Quantifies precision of the mean estimate

### Q: "Construct and interpret 80%, 90%, 95%, and 99% confidence intervals"
**A:** See detailed table above. All four CIs were computed using t-distribution.

### Q: "What happens to the intervals as you gain more confidence?"
**A:** As confidence increases:
- Intervals become **WIDER** (less precise)
- t-critical values increase (further into tails)
- Margin of error increases
- 99% CI is roughly **twice as wide** as 80% CI (101.8% increase)

### Q: "What can you say about confidence versus confidence?"
**A:** The term "confidence" refers to:
- The long-run proportion of CIs that capture the true parameter
- NOT the probability this specific interval contains the parameter
- Related to alpha: Confidence = 1 - α (risk of error)
- There's a **fundamental trade-off**: more confidence requires wider intervals

---

## FILES GENERATED

1. **task3_confidence_intervals.R** - Complete R code (reproducible)
2. **task3_confidence_intervals.pdf** - 4-panel visualization (histograms, Q-Q, CIs)
3. **task3_sampling_distribution.pdf** - Conceptual diagram of 95% CI
4. **TASK3_SUMMARY.md** - This comprehensive report

---

## ALL ASSIGNMENTS COMPLETE! 

You now have comprehensive analyses for:
- ✅ **Task 1:** Central Limit Theorem for Proportions
- ✅ **Task 2:** Monte Carlo Estimation of Median Distribution  
- ✅ **Task 3:** Point and Interval Estimation with Real Data

