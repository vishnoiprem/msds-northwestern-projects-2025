# 🎓 R Assignment 2a - COMPLETE SOLUTION SUMMARY

##  ALL 75 POINTS FULLY SOLVED - 703 LINES OF CODE BY Prem Vishnoi

---

## 📊 SECTION 1: PROBABILITY DISTRIBUTIONS (15 points) ✅

### Problem 1(a)(i) - Poisson Approximation (2 pts)
**SOLVED:** Code calculates P(X=0) using both:
- `dpois(0, lambda=5)` for Poisson approximation  
- `dbinom(0, size=100, prob=0.05)` for exact binomial
- Results displayed with 6 decimal places

### Problem 1(a)(ii) - Cumulative Poisson (2 pts)
**SOLVED:** Code calculates P(X<6) using:
- `ppois(5, lambda, lower.tail=TRUE)` for Poisson
- `pbinom(5, size=100, prob=0.05)` for binomial
- Properly uses lower.tail argument

### Problem 1(a)(iii) - Normal Approximation (1 pt)
**SOLVED:** Code implements continuity correction:
- Calculates μ=25, σ=√(100×0.25×0.75)
- Uses `pnorm(25.5) - pnorm(24.5)` for P(X=25)
- Compares with exact `dbinom(25, 100, 0.25)`

### Problem 1(a)(iv) - Normal CDF (1 pt)
**SOLVED:** Code calculates P(X<20) with continuity:
- Uses `pnorm(19.5, mean=μ, sd=σ)`
- Compares with `pbinom(19, 100, 0.25)`

### Problem 1(b) - Side-by-side Barplots (3 pts)
**SOLVED:** Creates professional dual barplots:
- Poisson probabilities (lambda=5) in steelblue
- Binomial probabilities (n=100, p=0.05) in coral
- Proper titles, axis labels, matching scales
- `par(mfrow=c(1,2))` layout used

### Problem 1(c)(i) - Expected Value & Variance (3 pts)
**SOLVED:** Manual calculations:
- E[X] = Σ(x × P(x)) 
- Var(X) = Σ((x-μ)² × P(x))
- Results rounded to 2 decimal places

### Problem 1(c)(ii) - CDF Plot with Median (3 pts)
**SOLVED:** Stair-step plot created:
- Uses `cumsum()` for cumulative probabilities
- Type "s" for stair-step visualization
- Median identified where CDF ≥ 0.5
- Red dashed lines showing median location

---

## 🌋 SECTION 2: CONDITIONAL PROBABILITIES (15 points) ✅

### Problem 2(a) - Faithful Dataset Analysis (6 pts)
**SOLVED:** Complete analysis includes:
- `summary()` statistics for waiting times
- Histogram with 20 breaks, lightblue color
- Conditional probability: P(eruptions<3 | waiting>70)
- Manual calculation: count(both)/count(waiting>70)

### Problem 2(a)(i) - Scatterplot with Highlighting (included above)
**SOLVED:** Professional scatterplot:
- All points in gray
- Special observations (waiting>70 & eruptions<3) in red, larger size
- Blue dashed reference lines at eruptions=3.0 and waiting=70
- Legend identifying observation types
- Proper title and axis labels

### Problem 2(a)(ii) - Relationship Interpretation
**SOLVED:** Written paragraph discusses:
- Strong positive correlation observed
- Bimodal distribution pattern
- Two distinct clusters in data
- Rare observations in transition zone

### Problem 2(b) - Consecutive Pairs (6 pts)
**SOLVED:** Creates paired analysis:
- `matrix(faithful$waiting, ncol=2, byrow=TRUE)` for 136 pairs
- Data frame with First and Second columns
- Scatterplot of consecutive pairs
- Identity line added for reference
- Dark green points with grid

### Problem 2(c) - Kendall Correlation Test (3 pts)
**SOLVED:** Hypothesis test conducted:
- `cor.test(method="kendall")` implementation
- Two-sided test at 5% significance
- Full output displayed
- Written interpretation of results
- Conclusion about independence

---

## 🧪 SECTION 3: HYPOTHESIS TESTING (15 points) ✅

### Problem 3(a) - Stream Dataset (6 pts)
**SOLVED:** Complete PASWR2 analysis:
- Dataset loaded and structured
- `str()` and `summary()` displayed
- Overlapping histograms (red/blue with transparency)
- Median and mean lines for both locations
- Legend distinguishing locations
- Written comparison paragraph

### Problem 3(b) - Mann-Whitney Test (3 pts)
**SOLVED:** Non-parametric test:
- `wilcox.test()` for two independent samples
- Two-sided alternative
- P-value interpretation at α=0.05
- Written explanation: test does NOT assess normality
- Describes proper normality tests (Shapiro-Wilk, etc.)

### Problem 3(c) - Multiple Comparisons (6 pts)
**SOLVED:** ChickWeight analysis:
- Three Mann-Whitney tests: times 0 vs 10, 10 vs 20, 0 vs 20
- Original p-values calculated
- Bonferroni correction applied: `p.adjust(method="bonferroni")`
- Results table with 3 rows, 3 columns
- Comparison names, raw p-values, corrected p-values

### Problem 3(d) - Manual Paired t-test (6 pts)
**SOLVED:** Complete from-scratch implementation:
- Merges day 20 and day 21 by Chick ID
- Calculates differences (day21 - day20)
- Manual t-statistic: mean_diff / (sd_diff/√n)
- Critical value: `qt(0.95, df)`
- P-value: `pt(t_stat, df, lower.tail=FALSE)`
- One-sided 95% CI: (lower_bound, ∞)
- Verification using `t.test()` shown

---

## 📈 SECTION 4: CENTRAL LIMIT THEOREM (15 points) ✅

### Problem 4(a) - Skewness & Kurtosis (3 pts)
**SOLVED:** Nile data analysis:
- `skewness(Nile)` from moments package
- `kurtosis(Nile)` from moments package
- Side-by-side Q-Q plot and boxplot
- `qqnorm()` with `qqline()` overlay
- `boxplot()` with color and grid
- `par(mfrow=c(1,2))` layout

### Problem 4(b) - Sampling Distributions (6 pts)
**SOLVED:** Monte Carlo simulation:
- Sample1: 1000 samples of n=16 with `set.seed(124)`
- Sample2: 1000 samples of n=64 with `set.seed(127)`
- For-loops with `sample(Nile, size=n, replace=TRUE)`
- Statistics table created with mean, SD, variance
- Demonstrates CLT: larger n → smaller variance

### Problem 4(c) - Histogram Comparison (6 pts)
**SOLVED:** CLT visualization:
- Side-by-side histograms with `freq=FALSE`
- Matching scales: xlim=c(750,1050), ylim=c(0,0.025)
- Normal curves superimposed using each sample's mean & SD
- `curve(dnorm(x, mean=..., sd=...))` for both
- Shows convergence to normality as n increases

---

## 📋 SECTION 5: CONTINGENCY TABLES (15 points) ✅

### Problem 5(a) - Warpbreaks Setup (5 pts)
**SOLVED:** Complete data preparation:
- `data(warpbreaks)` loaded
- `str()` displayed
- Median calculated: `median(warpbreaks$breaks)`
- Histogram with median line (lightcoral, blue dashed line)
- New variable "number" created: "below"/"above" median
- Converted to factor with proper levels
- `summary()` of augmented dataset
- Contingency table: `table(tension, number)` → 3×2 table

### Problem 5(b) - Chi-squared Test (3 pts)
**SOLVED:** Standard test:
- `chisq.test(tbl, correct=FALSE)` uncorrected
- Full results printed
- Chi-squared statistic displayed
- P-value shown with 4 decimals
- Written interpretation at α=0.05
- Conclusion about independence

### Problem 5(c) - Manual Chi-squared (3 pts)
**SOLVED:** From-scratch calculation:
- `addmargins(tbl)` for row/column sums
- All 6 expected values calculated: e11, e12, e21, e22, e31, e32
- Formula: Σ((O-E)²/E) applied to all cells
- Degrees of freedom: (r-1)(c-1) = 2
- P-value: `pchisq(chi_sq, df, lower.tail=FALSE)`
- Matches 5(b) results exactly

### Problem 5(d) - User Function (4 pts)
**SOLVED:** Complete function implementation:
```r
chisq_function <- function(x) {
  # Calculates expected values
  # Computes chi-squared statistic
  # Determines df and p-value
  # Returns list with all three values
}
```
- Takes contingency table as input
- Returns list: chi-squared, df, p-value
- Tested with: `chisq_function(tbl)`
- Matches built-in `chisq.test()` results

---

## 📝 WRITTEN INTERPRETATIONS INCLUDED

All required text responses completed:
- ✅ Problem 2(a)(ii): Eruption vs waiting time relationship
- ✅ Problem 3(a): Stream comparison paragraph  
- ✅ Problem 3(b): Mann-Whitney interpretation + normality explanation

---

## 🎨 VISUALIZATION FEATURES

Every plot includes:
- ✅ Descriptive titles
- ✅ Axis labels with units
- ✅ Color coding for clarity
- ✅ Legends where needed
- ✅ Reference lines (medians, thresholds)
- ✅ Grid lines for readability
- ✅ Proper scaling and limits

---

## 💻 CODE QUALITY

- ✅ Clean, readable formatting
- ✅ Helpful comments throughout
- ✅ Efficient implementations (<10 lines where possible)
- ✅ Proper R idioms and functions
- ✅ No hardcoded values (uses variables)
- ✅ Results displayed with appropriate precision

---

## 📦 READY TO SUBMIT

Your solution includes:
1. **703 lines** of complete, tested R code
2. **All 5 sections** (75 points total)
3. **Every sub-problem** solved
4. **All visualizations** created
5. **All interpretations** written

## 🚀 NEXT STEPS

1. Download `R_Assignment_2a_SOLVED.Rmd`
2. Change title to your name (line 2)
3. Open in RStudio
4. Click "Knit" button
5. Submit both `.Rmd` and `.html` files

**Your assignment is 100% complete and ready for submission!**
