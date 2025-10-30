# Assignment 2 - Task 3: Point and Interval Estimation with Real Data
# =========================================================================
# This script demonstrates point estimation and confidence interval construction
# using real-world data

# Set seed for reproducibility
set.seed(789)

# =========================================================================
# STEP 1: LOAD AND EXPLORE THE DATASET
# =========================================================================

cat(paste(rep("=", 75), collapse=""), "\n")
cat("TASK 3: POINT AND INTERVAL ESTIMATION WITH REAL DATA\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Try to load NutritionStudy data
# If not available, we'll create a similar synthetic dataset
use_synthetic <- TRUE
dataset_name <- "Synthetic Nutrition Study"

tryCatch({
  # Try loading from Stat2Data package
  library(Stat2Data)
  data(NutritionStudy)
  cat("✓ Successfully loaded NutritionStudy dataset from Stat2Data package\n\n")
  dataset_name <- "NutritionStudy"
  use_synthetic <- FALSE
}, error = function(e) {
  cat("Note: Stat2Data package not available. Creating synthetic nutrition dataset.\n\n")
  use_synthetic <- TRUE
})

if (use_synthetic) {
  # Create synthetic dataset similar to NutritionStudy
  set.seed(123)
  n_participants <- 315
  
  NutritionStudy <- data.frame(
    ID = 1:n_participants,
    Age = round(rnorm(n_participants, mean = 45, sd = 15)),
    Cholesterol = round(rnorm(n_participants, mean = 200, sd = 40)),
    BMI = round(rnorm(n_participants, mean = 26.5, sd = 4.5), 1),
    Calories = round(rnorm(n_participants, mean = 2100, sd = 450)),
    Fiber = round(rnorm(n_participants, mean = 18, sd = 6), 1),
    Vitamin_C = round(rnorm(n_participants, mean = 85, sd = 35)),
    Iron = round(rnorm(n_participants, mean = 14, sd = 4), 1),
    Protein = round(rnorm(n_participants, mean = 75, sd = 20))
  )
  
  # Ensure positive values
  NutritionStudy$Cholesterol <- pmax(NutritionStudy$Cholesterol, 120)
  NutritionStudy$BMI <- pmax(NutritionStudy$BMI, 16)
  NutritionStudy$Calories <- pmax(NutritionStudy$Calories, 1200)
  NutritionStudy$Fiber <- pmax(NutritionStudy$Fiber, 5)
  
  cat("✓ Created synthetic nutrition dataset\n\n")
}

# Display dataset information
cat("Dataset Overview:\n")
cat(paste(rep("-", 75), collapse=""), "\n")
cat(sprintf("Dataset Name: %s\n", dataset_name))
cat(sprintf("Number of observations: %d\n", nrow(NutritionStudy)))
cat(sprintf("Number of variables: %d\n\n", ncol(NutritionStudy)))

# Show first few rows
cat("First 6 rows of the dataset:\n")
print(head(NutritionStudy))

# Show structure
cat("\n\nDataset Structure:\n")
str(NutritionStudy)

# =========================================================================
# STEP 2: SELECT CONTINUOUS VARIABLE AND DEFINE POPULATION
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("STEP 2: VARIABLE SELECTION AND POPULATION DEFINITION\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Select a continuous numeric variable - using Cholesterol
# You can change this to any continuous variable in your dataset
selected_variable <- "Cholesterol"
data_vector <- NutritionStudy[[selected_variable]]

# Remove any missing values
data_vector <- data_vector[!is.na(data_vector)]
n <- length(data_vector)

cat("SELECTED VARIABLE: ", selected_variable, "\n")
cat(paste(rep("-", 75), collapse=""), "\n\n")

cat("POPULATION OF INTEREST:\n")
cat("The population consists of all adults who could potentially participate\n")
cat("in a nutrition study. This dataset represents a random sample of n =", n, "\n")
cat("participants from this population. We are interested in estimating the\n")
cat("true population mean", selected_variable, "level.\n\n")

cat("VARIABLE DESCRIPTION:\n")
cat("Cholesterol: Total cholesterol level measured in mg/dL (milligrams per deciliter)\n")
cat("- Normal range: < 200 mg/dL\n")
cat("- Borderline high: 200-239 mg/dL\n")
cat("- High: ≥ 240 mg/dL\n\n")

# Display descriptive statistics
cat("DESCRIPTIVE STATISTICS:\n")
cat(paste(rep("-", 75), collapse=""), "\n")
cat(sprintf("Sample size (n):           %d\n", n))
cat(sprintf("Minimum:                   %.2f\n", min(data_vector)))
cat(sprintf("1st Quartile (Q1):         %.2f\n", quantile(data_vector, 0.25)))
cat(sprintf("Median (Q2):               %.2f\n", median(data_vector)))
cat(sprintf("Mean:                      %.2f\n", mean(data_vector)))
cat(sprintf("3rd Quartile (Q3):         %.2f\n", quantile(data_vector, 0.75)))
cat(sprintf("Maximum:                   %.2f\n", max(data_vector)))
cat(sprintf("Range:                     %.2f\n", max(data_vector) - min(data_vector)))
cat(sprintf("Interquartile Range (IQR): %.2f\n", IQR(data_vector)))
cat(sprintf("Variance:                  %.2f\n", var(data_vector)))
cat(sprintf("Standard Deviation:        %.2f\n\n", sd(data_vector)))

# =========================================================================
# STEP 3: POINT ESTIMATES
# =========================================================================

cat("\n", paste(rep("=", 75), collapse=""), "\n")
cat("STEP 3: POINT ESTIMATES\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Calculate point estimates
sample_mean <- mean(data_vector)
sample_sd <- sd(data_vector)
sample_se <- sample_sd / sqrt(n)

cat("POINT ESTIMATE FOR POPULATION MEAN (μ):\n")
cat(paste(rep("-", 75), collapse=""), "\n")
cat(sprintf("Sample Mean (x̄) = %.4f mg/dL\n\n", sample_mean))

cat("INTERPRETATION:\n")
cat(sprintf("Based on our sample of %d participants, we estimate that the average\n", n))
cat(sprintf("cholesterol level in the population is %.2f mg/dL. This is our single\n", sample_mean))
cat("best guess (point estimate) for the true population mean. However, we\n")
cat("acknowledge that this estimate has sampling variability and is unlikely\n")
cat("to be exactly equal to the true population parameter.\n\n")

if (sample_mean < 200) {
  cat("Clinical Note: The estimated mean is in the 'desirable' range (< 200 mg/dL).\n\n")
} else if (sample_mean < 240) {
  cat("Clinical Note: The estimated mean is in the 'borderline high' range (200-239 mg/dL).\n\n")
} else {
  cat("Clinical Note: The estimated mean is in the 'high' range (≥ 240 mg/dL).\n\n")
}

cat("\nPOINT ESTIMATE FOR POPULATION STANDARD DEVIATION (σ):\n")
cat(paste(rep("-", 75), collapse=""), "\n")
cat(sprintf("Sample Standard Deviation (s) = %.4f mg/dL\n\n", sample_sd))

cat("INTERPRETATION:\n")
cat(sprintf("The standard deviation of %.2f mg/dL indicates the typical amount of\n", sample_sd))
cat("variation in cholesterol levels around the mean. About 68%% of individuals\n")
cat("in our sample have cholesterol levels within one standard deviation of the\n")
cat(sprintf("mean (approximately %.2f to %.2f mg/dL, assuming normality).\n\n", 
            sample_mean - sample_sd, sample_mean + sample_sd))

cat("\nSTANDARD ERROR OF THE MEAN:\n")
cat(paste(rep("-", 75), collapse=""), "\n")
cat(sprintf("Standard Error (SE) = s / √n = %.4f mg/dL\n\n", sample_se))

cat("INTERPRETATION:\n")
cat("The standard error represents the estimated standard deviation of the\n")
cat("sampling distribution of the mean. It quantifies the precision of our\n")
cat("sample mean as an estimate of the population mean. Smaller SE indicates\n")
cat("more precise estimation.\n\n")

# =========================================================================
# STEP 4: CONFIDENCE INTERVALS
# =========================================================================

cat("\n", paste(rep("=", 75), collapse=""), "\n")
cat("STEP 4: CONFIDENCE INTERVALS FOR POPULATION MEAN\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Confidence levels to compute
confidence_levels <- c(0.80, 0.90, 0.95, 0.99)
alpha_levels <- 1 - confidence_levels

# Calculate degrees of freedom
df <- n - 1

# Store results
ci_results <- data.frame(
  Confidence = paste0(confidence_levels * 100, "%"),
  Alpha = alpha_levels,
  t_critical = numeric(length(confidence_levels)),
  Margin_Error = numeric(length(confidence_levels)),
  Lower_Bound = numeric(length(confidence_levels)),
  Upper_Bound = numeric(length(confidence_levels)),
  Width = numeric(length(confidence_levels)),
  stringsAsFactors = FALSE
)

cat("CONFIDENCE INTERVAL CALCULATIONS:\n")
cat(paste(rep("-", 75), collapse=""), "\n\n")

for (i in 1:length(confidence_levels)) {
  conf_level <- confidence_levels[i]
  alpha <- alpha_levels[i]
  
  # Calculate t-critical value
  t_crit <- qt(1 - alpha/2, df)
  
  # Calculate margin of error
  margin_error <- t_crit * sample_se
  
  # Calculate confidence interval
  ci_lower <- sample_mean - margin_error
  ci_upper <- sample_mean + margin_error
  ci_width <- ci_upper - ci_lower
  
  # Store results
  ci_results$t_critical[i] <- t_crit
  ci_results$Margin_Error[i] <- margin_error
  ci_results$Lower_Bound[i] <- ci_lower
  ci_results$Upper_Bound[i] <- ci_upper
  ci_results$Width[i] <- ci_width
  
  # Print detailed output
  cat(sprintf("%d%% CONFIDENCE INTERVAL:\n", conf_level * 100))
  cat(sprintf("  Confidence Level: %.2f (Alpha = %.2f, α/2 = %.3f)\n", 
              conf_level, alpha, alpha/2))
  cat(sprintf("  Degrees of Freedom: %d\n", df))
  cat(sprintf("  t-critical value: %.4f\n", t_crit))
  cat(sprintf("  Margin of Error: %.4f mg/dL\n", margin_error))
  cat(sprintf("  Confidence Interval: [%.4f, %.4f] mg/dL\n", ci_lower, ci_upper))
  cat(sprintf("  Interval Width: %.4f mg/dL\n\n", ci_width))
  
  cat("  INTERPRETATION:\n")
  cat(sprintf("  We are %d%% confident that the true population mean cholesterol\n", 
              conf_level * 100))
  cat(sprintf("  level lies between %.2f and %.2f mg/dL. This means that if we\n", 
              ci_lower, ci_upper))
  cat(sprintf("  repeated this sampling process many times, approximately %d%% of\n", 
              conf_level * 100))
  cat("  the confidence intervals constructed would contain the true population mean.\n\n")
  cat(paste(rep("-", 75), collapse=""), "\n\n")
}

# Display summary table
cat("\nSUMMARY TABLE OF CONFIDENCE INTERVALS:\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")
print(ci_results, row.names = FALSE, digits = 4)

# =========================================================================
# STEP 5: ANALYSIS OF CONFIDENCE vs. INTERVAL WIDTH
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("STEP 5: WHAT HAPPENS AS CONFIDENCE INCREASES?\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

cat("RELATIONSHIP BETWEEN CONFIDENCE AND INTERVAL WIDTH:\n")
cat(paste(rep("-", 75), collapse=""), "\n\n")

# Calculate percentage increases in width
width_80 <- ci_results$Width[1]
for (i in 1:nrow(ci_results)) {
  pct_increase <- ((ci_results$Width[i] - width_80) / width_80) * 100
  cat(sprintf("%s CI: Width = %.4f mg/dL (%.1f%% wider than 80%% CI)\n", 
              ci_results$Confidence[i], ci_results$Width[i], pct_increase))
}

cat("\n\nKEY OBSERVATIONS:\n")
cat("1. As confidence level increases, the interval width INCREASES\n")
cat("2. Higher confidence requires a wider interval to capture the true parameter\n")
cat("3. There is a TRADE-OFF between confidence and precision:\n")
cat("   - More confidence → Wider interval → Less precise estimate\n")
cat("   - Less confidence → Narrower interval → More precise estimate\n\n")

cat("MATHEMATICAL EXPLANATION:\n")
cat("The confidence interval formula is: CI = x̄ ± t(α/2, df) × SE\n")
cat("As confidence increases:\n")
cat("  • Alpha (α) decreases\n")
cat("  • t-critical value increases (further out in the tails)\n")
cat("  • Margin of error increases\n")
cat("  • Interval width increases\n\n")

cat("ANALOGY:\n")
cat("Think of confidence intervals like casting a fishing net:\n")
cat("  • 80%% CI: Narrow net - higher risk of missing the fish (α = 0.20)\n")
cat("  • 90%% CI: Medium net - moderate risk (α = 0.10)\n")
cat("  • 95%% CI: Wide net - low risk (α = 0.05)\n")
cat("  • 99%% CI: Very wide net - very low risk (α = 0.01)\n\n")

cat("CONFIDENCE vs. CONFIDENCE INTERPRETATION:\n")
cat(paste(rep("-", 75), collapse=""), "\n")
cat("The term 'confidence' has a specific statistical meaning:\n\n")

cat("• CONFIDENCE LEVEL (1 - α):\n")
cat("  The long-run proportion of confidence intervals that would contain\n")
cat("  the true population parameter if we repeated the sampling process\n")
cat("  many times. It is NOT the probability that this specific interval\n")
cat("  contains the true mean (the parameter is fixed, not random).\n\n")

cat("• RELATIONSHIP TO ALPHA (α):\n")
cat("  Alpha represents the risk we're willing to take of being wrong.\n")
cat("  - α = 0.20 (80%% confidence): We accept a 20%% risk of error\n")
cat("  - α = 0.05 (95%% confidence): We accept only a 5%% risk of error\n")
cat("  - α = 0.01 (99%% confidence): We accept only a 1%% risk of error\n\n")

cat("• PRECISION vs. CONFIDENCE TRADE-OFF:\n")
cat("  We cannot have both maximum confidence and maximum precision.\n")
cat("  - Want narrow interval? Use lower confidence (e.g., 80%%)\n")
cat("  - Want high confidence? Accept wider interval (e.g., 99%%)\n")
cat("  - Balanced choice: 95%% confidence (conventional in many fields)\n\n")

cat("• PRACTICAL IMPLICATIONS:\n")
cat("  - Research: Typically use 95%% confidence (balance of precision and confidence)\n")
cat("  - Medical/Safety: May use 99%% confidence (minimize risk of error)\n")
cat("  - Exploratory: May use 80-90%% confidence (prioritize precision)\n\n")

# =========================================================================
# STEP 6: VISUALIZATIONS
# =========================================================================

cat(paste(rep("=", 75), collapse=""), "\n")
cat("STEP 6: CREATING VISUALIZATIONS\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Create comprehensive PDF with all plots
pdf("/home/claude/task3_confidence_intervals.pdf", width = 14, height = 10)
par(mfrow = c(2, 2), mar = c(5, 5, 4, 2))

# Plot 1: Histogram of data with normal overlay
hist(data_vector, breaks = 30, freq = FALSE,
     main = sprintf("Distribution of %s\n(n = %d)", selected_variable, n),
     xlab = sprintf("%s (mg/dL)", selected_variable),
     ylab = "Density",
     col = "lightblue", border = "black")

# Add density curve
lines(density(data_vector), col = "darkblue", lwd = 2)

# Add normal overlay
x_seq <- seq(min(data_vector), max(data_vector), length.out = 200)
lines(x_seq, dnorm(x_seq, mean = sample_mean, sd = sample_sd),
      col = "red", lwd = 2, lty = 2)

# Add mean line
abline(v = sample_mean, col = "darkgreen", lwd = 2, lty = 1)

legend("topright", 
       legend = c("Observed Data", "Normal Curve", "Sample Mean"),
       col = c("darkblue", "red", "darkgreen"),
       lwd = 2, lty = c(1, 2, 1), bty = "n")

# Plot 2: Q-Q plot to check normality
qqnorm(data_vector, 
       main = sprintf("Q-Q Plot: %s", selected_variable),
       pch = 19, col = "steelblue")
qqline(data_vector, col = "red", lwd = 2)
text(min(qqnorm(data_vector, plot.it = FALSE)$x),
     max(qqnorm(data_vector, plot.it = FALSE)$y) * 0.9,
     "Points near the line\nindicate normality",
     pos = 4, cex = 0.9)

# Plot 3: Confidence intervals visualization
plot(1, type = "n", xlim = c(min(ci_results$Lower_Bound) - 5, 
                              max(ci_results$Upper_Bound) + 5),
     ylim = c(0.5, length(confidence_levels) + 0.5),
     xlab = sprintf("%s (mg/dL)", selected_variable),
     ylab = "",
     main = "Confidence Intervals at Different Levels",
     yaxt = "n")

# Add y-axis labels
axis(2, at = 1:length(confidence_levels), 
     labels = ci_results$Confidence, las = 1)

# Add grid
abline(v = sample_mean, col = "darkgreen", lwd = 2, lty = 1)

# Plot intervals
colors <- c("coral", "gold", "skyblue", "mediumpurple")
for (i in 1:length(confidence_levels)) {
  segments(ci_results$Lower_Bound[i], i,
           ci_results$Upper_Bound[i], i,
           col = colors[i], lwd = 4)
  points(sample_mean, i, pch = 19, cex = 1.5, col = "darkgreen")
}

legend("topright", 
       legend = c("Sample Mean", ci_results$Confidence),
       col = c("darkgreen", colors),
       lwd = c(2, rep(4, 4)), 
       lty = c(1, rep(1, 4)),
       bty = "n", cex = 0.8)

# Plot 4: Interval width vs confidence level
plot(confidence_levels * 100, ci_results$Width,
     type = "b", pch = 19, cex = 2, col = "darkblue", lwd = 2,
     main = "Interval Width vs. Confidence Level",
     xlab = "Confidence Level (%)",
     ylab = "Interval Width (mg/dL)",
     xlim = c(75, 100),
     ylim = c(0, max(ci_results$Width) * 1.1))

# Add grid
grid()

# Add text labels
for (i in 1:nrow(ci_results)) {
  text(confidence_levels[i] * 100, ci_results$Width[i],
       sprintf("%.2f", ci_results$Width[i]),
       pos = 3, cex = 0.8)
}

# Add annotation
text(85, max(ci_results$Width) * 0.9,
     "Higher confidence\n= Wider interval",
     col = "red", cex = 1.1, font = 2)

dev.off()

cat("✓ Main visualization saved to: task3_confidence_intervals.pdf\n\n")

# Create additional plot showing sampling distribution concept
pdf("/home/claude/task3_sampling_distribution.pdf", width = 10, height = 8)
par(mfrow = c(1, 1), mar = c(5, 5, 4, 2))

# Plot sampling distribution
x_range <- seq(sample_mean - 4*sample_se, sample_mean + 4*sample_se, length.out = 500)
y_vals <- dnorm(x_range, mean = sample_mean, sd = sample_se)

plot(x_range, y_vals, type = "l", lwd = 3, col = "darkblue",
     main = sprintf("Sampling Distribution of the Mean\n95%% Confidence Interval"),
     xlab = sprintf("Sample Mean %s (mg/dL)", selected_variable),
     ylab = "Probability Density",
     ylim = c(0, max(y_vals) * 1.1))

# Shade 95% CI region
ci_95_lower <- ci_results$Lower_Bound[3]  # 95% is 3rd row
ci_95_upper <- ci_results$Upper_Bound[3]

x_shade <- x_range[x_range >= ci_95_lower & x_range <= ci_95_upper]
y_shade <- dnorm(x_shade, mean = sample_mean, sd = sample_se)

polygon(c(x_shade, rev(x_shade)), c(rep(0, length(x_shade)), rev(y_shade)),
        col = rgb(0, 0, 1, 0.3), border = NA)

# Add vertical lines
abline(v = sample_mean, col = "darkgreen", lwd = 2)
abline(v = ci_95_lower, col = "red", lwd = 2, lty = 2)
abline(v = ci_95_upper, col = "red", lwd = 2, lty = 2)

# Add text annotations
text(sample_mean, max(y_vals) * 1.05,
     sprintf("x̄ = %.2f", sample_mean),
     pos = 3, col = "darkgreen", font = 2)

text(ci_95_lower, max(y_vals) * 0.5,
     sprintf("Lower\n%.2f", ci_95_lower),
     pos = 2, col = "red", cex = 0.9)

text(ci_95_upper, max(y_vals) * 0.5,
     sprintf("Upper\n%.2f", ci_95_upper),
     pos = 4, col = "red", cex = 0.9)

text(sample_mean, max(y_vals) * 0.25,
     "95% of the area\nunder the curve",
     col = "blue", font = 2)

legend("topright",
       legend = c("Sampling Distribution", "Sample Mean", "95% CI Bounds"),
       col = c("darkblue", "darkgreen", "red"),
       lwd = c(3, 2, 2),
       lty = c(1, 1, 2),
       bty = "n")

dev.off()

cat("✓ Sampling distribution plot saved to: task3_sampling_distribution.pdf\n\n")

# =========================================================================
# STEP 7: NORMALITY CHECK
# =========================================================================

cat("\n", paste(rep("=", 75), collapse=""), "\n")
cat("STEP 7: CHECKING ASSUMPTIONS\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

cat("For confidence intervals based on t-distribution to be valid, we need:\n")
cat("1. Random sampling from the population\n")
cat("2. Independence of observations\n")
cat("3. Approximate normality of the population OR large sample size (n ≥ 30)\n\n")

# Shapiro-Wilk test
if (n <= 5000) {
  shapiro_result <- shapiro.test(data_vector)
  cat("SHAPIRO-WILK NORMALITY TEST:\n")
  cat(sprintf("  W-statistic = %.4f\n", shapiro_result$statistic))
  cat(sprintf("  p-value = %.4f\n\n", shapiro_result$p.value))
  
  if (shapiro_result$p.value > 0.05) {
    cat("  Result: FAIL TO REJECT normality assumption (p > 0.05)\n")
    cat("  Conclusion: Data are consistent with a normal distribution.\n\n")
  } else {
    cat("  Result: REJECT normality assumption (p < 0.05)\n")
    cat("  Conclusion: Data show departure from normality.\n")
    cat(sprintf("  However, with n = %d, the Central Limit Theorem suggests that\n", n))
    cat("  the sampling distribution of the mean is approximately normal,\n")
    cat("  so our confidence intervals are still valid.\n\n")
  }
}

# Skewness and Kurtosis
skewness <- mean((data_vector - sample_mean)^3) / sample_sd^3
kurtosis <- mean((data_vector - sample_mean)^4) / sample_sd^4 - 3

cat("DISTRIBUTION SHAPE METRICS:\n")
cat(sprintf("  Skewness: %.4f ", skewness))
if (abs(skewness) < 0.5) {
  cat("(approximately symmetric)\n")
} else if (skewness > 0) {
  cat("(right-skewed)\n")
} else {
  cat("(left-skewed)\n")
}

cat(sprintf("  Excess Kurtosis: %.4f ", kurtosis))
if (abs(kurtosis) < 0.5) {
  cat("(approximately mesokurtic, like normal)\n")
} else if (kurtosis > 0) {
  cat("(leptokurtic, heavier tails than normal)\n")
} else {
  cat("(platykurtic, lighter tails than normal)\n")
}

cat("\n  Note: For normal distribution, skewness = 0 and excess kurtosis = 0\n\n")

cat(sprintf("SAMPLE SIZE: n = %d\n", n))
if (n >= 30) {
  cat("✓ Sample size is sufficient (n ≥ 30) for CLT to apply.\n")
  cat("  Even if the population is not perfectly normal, the sampling\n")
  cat("  distribution of the mean is approximately normal.\n")
} else {
  cat("⚠ Sample size is small (n < 30). Check Q-Q plot carefully.\n")
  cat("  If data are approximately normal, t-procedures are valid.\n")
}

# =========================================================================
# FINAL SUMMARY
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("TASK 3 COMPLETE - SUMMARY\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

cat("DATASET: ", dataset_name, "\n")
cat("VARIABLE: ", selected_variable, "\n")
cat("SAMPLE SIZE: ", n, "\n\n")

cat("POINT ESTIMATES:\n")
cat(sprintf("  Population Mean (μ):   %.2f mg/dL\n", sample_mean))
cat(sprintf("  Population SD (σ):     %.2f mg/dL\n", sample_sd))
cat(sprintf("  Standard Error (SE):   %.2f mg/dL\n\n", sample_se))

cat("CONFIDENCE INTERVALS:\n")
for (i in 1:nrow(ci_results)) {
  cat(sprintf("  %s: [%.2f, %.2f] mg/dL  (width: %.2f)\n",
              ci_results$Confidence[i],
              ci_results$Lower_Bound[i],
              ci_results$Upper_Bound[i],
              ci_results$Width[i]))
}

cat("\n\nKEY INSIGHT:\n")
cat("As confidence increases from 80%% to 99%%, the interval width increases\n")
cat(sprintf("from %.2f to %.2f mg/dL (%.1f%% increase). This illustrates the\n",
            ci_results$Width[1], ci_results$Width[4],
            ((ci_results$Width[4] - ci_results$Width[1]) / ci_results$Width[1]) * 100))
cat("fundamental trade-off in statistical inference: higher confidence comes\n")
cat("at the cost of less precise estimates (wider intervals).\n\n")

cat(paste(rep("=", 75), collapse=""), "\n")
cat("All analysis complete! Check the PDF files for visualizations.\n")
cat(paste(rep("=", 75), collapse=""), "\n")
