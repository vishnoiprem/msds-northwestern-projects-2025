# ASSIGNMENT 2 - QUICK REFERENCE GUIDE
# ================================================================

## 🎯 ONE-PAGE SUMMARY

### TASK 1: Central Limit Theorem for Proportions
**Question:** Does the sampling distribution of p̂ follow a normal curve?  
**Answer:** YES, when np ≥ 10 and n(1-p) ≥ 10  
**Key Finding:** SE = √[p(1-p)/n], maximized at p = 0.5  
**Best Plot:** task1_part_a_plots.pdf (shows normality improves with n)

### TASK 2: Median Sampling Distribution
**Question:** Does the sampling distribution of the median follow a normal curve?  
**Answer:** DEPENDS - YES for symmetric populations, NO for skewed  
**Key Finding:** Median needs larger n than mean for normality  
**Best Plot:** task2_part2_exponential.pdf (shows median vs mean for skewed data)

### TASK 3: Confidence Intervals
**Question:** What happens as confidence increases?  
**Answer:** Interval width INCREASES (confidence-precision trade-off)  
**Key Finding:** 99% CI is 2× wider than 80% CI  
**Best Plot:** task3_confidence_intervals.pdf (panel 3 shows nested CIs)

---

## 📊 KEY NUMBERS TO REPORT

### Task 1 Results
- n=10:  Simulated SE = 0.1583 vs. Theoretical = 0.1581 (99.9% match)
- n=100: Simulated SE = 0.0496 vs. Theoretical = 0.0500 (99.3% match)
- All differences < 1.3% → CLT confirmed!

### Task 2 Results
**Normal Population (n=100):**
- Median SE = 0.1247, Mean SE = 0.0995, Ratio = 1.25 ✓ matches theory
- Both pass normality tests ✓

**Exponential Population (n=100):**
- Median skewness = 0.318 (FAILS normality) ✗
- Mean skewness = 0.080 (better, but still skewed)
- Median SE / Mean SE ≈ 1.0 (similar variability)

### Task 3 Results
**Point Estimates:**
- Mean = 200.44 mg/dL
- SD = 38.61 mg/dL
- SE = 2.18 mg/dL

**Confidence Intervals:**
- 80%: [197.65, 203.24] - width 5.59
- 95%: [196.16, 204.72] - width 8.56 (+53% wider)
- 99%: [194.80, 206.08] - width 11.28 (+102% wider)

---

## 💬 ONE-SENTENCE ANSWERS TO KEY QUESTIONS

**Q: Why does the median not always follow a normal distribution?**
A: The Central Limit Theorem applies to sums (means), not order statistics (medians), 
   so the median converges to normality more slowly and fails entirely for skewed populations.

**Q: What happens to confidence intervals as confidence increases?**
A: Intervals become wider because higher confidence requires capturing more area under 
   the t-distribution curve, increasing the t-critical value and margin of error.

**Q: When should you use 80% vs 99% confidence?**
A: Use 80% when precision is more important than confidence (exploratory research); 
   use 99% when minimizing error risk is critical (medical/safety applications).

**Q: What does "95% confidence" really mean?**
A: If we repeated the sampling process many times, approximately 95% of the constructed 
   intervals would contain the true population parameter.

---

## 📁 FILE LOCATION QUICK REFERENCE

All files are in: `/mnt/user-data/outputs/`

**R Code (run these):**
- task1_clt_simplified.R
- task2_monte_carlo_median.R  
- task3_confidence_intervals.R

**Best Plots (include these in report):**
- task1_part_a_plots.pdf (CLT demonstration)
- task2_part2_exponential.pdf (median vs mean comparison)
- task3_confidence_intervals.pdf (all CIs visualized)

**Full Reports (read these):**
- TASK1_SUMMARY.md
- TASK2_SUMMARY.md
- TASK3_SUMMARY.md
- ASSIGNMENT2_MASTER_SUMMARY.md

---

## ✍️ WRITING TIPS

**DO:**
✓ Use your own words (don't copy-paste from summaries)
✓ Include specific numbers from your results
✓ Reference plots by figure number
✓ Explain WHY, not just WHAT
✓ Use proper statistical terminology
✓ Interpret results in context (cholesterol levels, etc.)

**DON'T:**
✗ Say "the probability that μ is in the CI" (wrong interpretation!)
✗ Confuse SD (data variability) with SE (estimate precision)
✗ Forget to state assumptions (normality, independence, etc.)
✗ Use vague language ("the results were good")
✗ Ignore the practical meaning of your findings

---

## 🎯 REPORT STRUCTURE TEMPLATE

### Introduction (1-2 paragraphs)
- State the three objectives
- Mention the methods (simulation, real data analysis)
- Preview main findings

### Task 1: CLT for Proportions
- Methods: "We simulated 10,000 samples for each scenario..."
- Results: "Standard errors matched theoretical predictions within 1.3%..."
- Discussion: "This confirms the Central Limit Theorem applies to..."
- Figure: Include task1_part_a_plots.pdf

### Task 2: Median Distribution  
- Methods: "Monte Carlo simulation with 10,000 replications..."
- Results: "For symmetric populations, median was normal. For skewed..."
- Discussion: "The median's failure to achieve normality for skewed data..."
- Figure: Include task2_part2_exponential.pdf

### Task 3: Confidence Intervals
- Methods: "We analyzed cholesterol data (n=315)..."
- Results: "Mean = 200.44 mg/dL, 95% CI = [196.16, 204.72]..."
- Discussion: "The 99% CI was 102% wider than 80% CI, demonstrating..."
- Figure: Include task3_confidence_intervals.pdf

### Conclusion (1 paragraph)
- Summarize main findings from all three tasks
- State the key insight (confidence-precision trade-off)
- Mention broader implications

---

## 🔢 FORMULAS TO INCLUDE

**Task 1:**
- SE(p̂) = √[p(1-p)/n]
- Success-failure condition: np ≥ 10 AND n(1-p) ≥ 10

**Task 2:**
- For normal population: Median efficiency ≈ 64% of mean
- SE(median) ≈ 1.25 × SE(mean)

**Task 3:**
- CI = x̄ ± t(α/2, df) × SE
- SE = s / √n
- df = n - 1

---

## ⚡ COMMON MISTAKES TO AVOID

1. **Wrong CI interpretation:**
   ❌ "There's a 95% probability that μ is in [196, 205]"
   ✅ "We're 95% confident that μ is in [196, 205]"

2. **Confusing SE and SD:**
   ❌ "The SE is 38.61" (that's the SD!)
   ✅ "The SE is 2.18, much smaller than SD = 38.61"

3. **Ignoring skewness impact:**
   ❌ "The median is always normally distributed"
   ✅ "The median is normal for symmetric populations only"

4. **Misunderstanding confidence:**
   ❌ "Higher confidence is always better"
   ✅ "Higher confidence requires wider intervals (trade-off)"

---

## 📊 TABLES TO INCLUDE

**Task 1 Comparison Table:**
| n   | Theoretical SE | Simulated SE | % Difference |
|-----|---------------|--------------|--------------|
| 10  | 0.1581        | 0.1583       | 0.10%        |
| 30  | 0.0913        | 0.0910       | 0.27%        |
| 100 | 0.0500        | 0.0496       | 0.74%        |
| 250 | 0.0316        | 0.0317       | 0.21%        |

**Task 3 Confidence Intervals:**
| Confidence | Lower  | Upper  | Width |
|------------|--------|--------|-------|
| 80%        | 197.65 | 203.24 | 5.59  |
| 90%        | 196.85 | 204.03 | 7.18  |
| 95%        | 196.16 | 204.72 | 8.56  |
| 99%        | 194.80 | 206.08 | 11.28 |

---

## 🎓 LEARNING OUTCOMES CHECKLIST

Can you explain:
- [ ] Why CLT guarantees normality for sample means?
- [ ] Why median doesn't always follow normal distribution?
- [ ] What standard error measures?
- [ ] Difference between confidence level and confidence interval?
- [ ] Why higher confidence requires wider intervals?
- [ ] When to use 95% vs 99% confidence?
- [ ] What "95% confident" really means?
- [ ] Why we need both point and interval estimates?

If yes to all → You're ready! ✅

---

## 🚀 FINAL PRE-SUBMISSION CHECKLIST

- [ ] All three tasks addressed ✅
- [ ] R code runs without errors ✅
- [ ] Plots generated and saved ✅
- [ ] Results interpreted correctly ✅
- [ ] Written in own words ✅
- [ ] Proper citations included ✅
- [ ] Grammar/spelling checked ✅
- [ ] Figures numbered and captioned ✅
- [ ] All questions answered ✅
- [ ] Ready to submit! 🎉

---

**Good luck with your assignment!**

Remember: These materials are comprehensive guides. Your report should be 
concise and in your own words, demonstrating YOUR understanding of the concepts.

**Estimated Time to Write Report:** 2-3 hours  
**Recommended Length:** 8-12 pages (including figures)  
**Suggested Figures:** 6-9 (2-3 per task)

---

Need to find something quickly?
- See ASSIGNMENT2_MASTER_SUMMARY.md for full details
- See TASKX_SUMMARY.md for task-specific information
- See .R files for reproducible code
- See .pdf files for all visualizations

