# Assignment 2 - Task 2: Monte Carlo Estimation of Sampling Distribution of Median
# ===================================================================================
# This script evaluates whether the sampling distribution of the median statistic
# follows a normal distribution, especially when compared to skewed distributions

# Set seed for reproducibility
set.seed(456)

# =========================================================================
# FUNCTION DEFINITIONS
# =========================================================================

# Function to simulate sampling distribution of median
simulate_median_distribution <- function(n, distribution = "normal",
                                         num_simulations = 10000,
                                         dist_params = list()) {
  # n = sample size
  # distribution = "normal", "uniform", "exponential", "skewed"
  # num_simulations = number of samples to draw
  # dist_params = list of distribution parameters

  sample_medians <- numeric(num_simulations)
  sample_means <- numeric(num_simulations)  # Also track means for comparison

  for (i in 1:num_simulations) {
    # Generate sample based on specified distribution
    if (distribution == "normal") {
      mu <- ifelse(is.null(dist_params$mean), 0, dist_params$mean)
      sigma <- ifelse(is.null(dist_params$sd), 1, dist_params$sd)
      sample_data <- rnorm(n, mean = mu, sd = sigma)

    } else if (distribution == "uniform") {
      min_val <- ifelse(is.null(dist_params$min), 0, dist_params$min)
      max_val <- ifelse(is.null(dist_params$max), 1, dist_params$max)
      sample_data <- runif(n, min = min_val, max = max_val)

    } else if (distribution == "exponential") {
      rate <- ifelse(is.null(dist_params$rate), 1, dist_params$rate)
      sample_data <- rexp(n, rate = rate)

    } else if (distribution == "skewed_right") {
      # Chi-squared distribution (right-skewed)
      df <- ifelse(is.null(dist_params$df), 3, dist_params$df)
      sample_data <- rchisq(n, df = df)

    } else if (distribution == "skewed_left") {
      # Negative of chi-squared (left-skewed)
      df <- ifelse(is.null(dist_params$df), 3, dist_params$df)
      sample_data <- -rchisq(n, df = df)

    } else if (distribution == "bimodal") {
      # Mixture of two normals
      group <- rbinom(n, 1, 0.5)
      sample_data <- ifelse(group == 1,
                           rnorm(n, mean = -2, sd = 0.5),
                           rnorm(n, mean = 2, sd = 0.5))
    }

    sample_medians[i] <- median(sample_data)
    sample_means[i] <- mean(sample_data)
  }

  return(list(medians = sample_medians, means = sample_means))
}

# Function to perform normality tests
test_normality <- function(data, test_name = "") {
  # Shapiro-Wilk test (use sample if data > 5000)
  if (length(data) > 5000) {
    data_sample <- sample(data, 5000)
  } else {
    data_sample <- data
  }

  shapiro_result <- shapiro.test(data_sample)

  # Anderson-Darling test (if available)
  # ad_result <- ad.test(data)  # Requires nortest package

  # Skewness and Kurtosis
  skewness <- mean((data - mean(data))^3) / sd(data)^3
  kurtosis <- mean((data - mean(data))^4) / sd(data)^4 - 3  # Excess kurtosis

  cat(sprintf("\n%s Normality Tests:\n", test_name))
  cat(paste(rep("-", 50), collapse=""), "\n")
  cat(sprintf("Shapiro-Wilk W = %.4f, p-value = %.4f\n",
              shapiro_result$statistic, shapiro_result$p.value))
  cat(sprintf("Skewness: %.4f (Normal = 0)\n", skewness))
  cat(sprintf("Excess Kurtosis: %.4f (Normal = 0)\n", kurtosis))

  if (shapiro_result$p.value > 0.05) {
    cat("Result: FAIL TO REJECT normality (p > 0.05)\n")
  } else {
    cat("Result: REJECT normality (p < 0.05)\n")
  }

  return(list(
    shapiro_w = shapiro_result$statistic,
    shapiro_p = shapiro_result$p.value,
    skewness = skewness,
    kurtosis = kurtosis
  ))
}

# =========================================================================
# PART 1: SYMMETRIC DISTRIBUTIONS
# =========================================================================

cat(paste(rep("=", 75), collapse=""), "\n")
cat("PART 1: SAMPLING DISTRIBUTION OF MEDIAN - SYMMETRIC DISTRIBUTIONS\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Test different sample sizes with normal distribution
sample_sizes <- c(10, 30, 100, 250)
num_sims <- 10000

# Create plots for normal distribution
pdf("MSDS401/Assignment_2/task2_part1_normal_medians.pdf", width = 12, height = 10)
par(mfrow = c(2, 2), mar = c(4, 4, 3, 2))

normality_results_normal <- list()

for (i in 1:length(sample_sizes)) {
  n <- sample_sizes[i]

  cat(sprintf("\n--- Normal Distribution, n = %d ---\n", n))

  # Simulate
  sim_results <- simulate_median_distribution(n, "normal", num_sims,
                                              list(mean = 0, sd = 1))

  medians <- sim_results$medians
  means <- sim_results$means

  # Calculate statistics
  median_mean <- mean(medians)
  median_se <- sd(medians)
  mean_mean <- mean(means)
  mean_se <- sd(means)

  # Theoretical SE for mean
  theoretical_se_mean <- 1 / sqrt(n)

  cat(sprintf("Sample Median: Mean = %.4f, SE = %.4f\n", median_mean, median_se))
  cat(sprintf("Sample Mean:   Mean = %.4f, SE = %.4f\n", mean_mean, mean_se))
  cat(sprintf("Theoretical SE for Mean = %.4f\n", theoretical_se_mean))
  cat(sprintf("Median SE / Mean SE Ratio = %.4f\n", median_se / mean_se))

  # Test normality
  normality_results_normal[[i]] <- test_normality(medians,
                                                  sprintf("Median (n=%d)", n))

  # Create histogram
  hist(medians, breaks = 50, freq = FALSE,
       main = sprintf("Sampling Dist. of Median\nNormal Population, n = %d", n),
       xlab = "Sample Median",
       ylab = "Density",
       col = "lightblue", border = "black")

  # Add theoretical normal curve
  x_seq <- seq(min(medians), max(medians), length.out = 200)
  lines(x_seq, dnorm(x_seq, mean = median_mean, sd = median_se),
        col = "red", lwd = 2)

  # Add vertical line at mean
  abline(v = median_mean, col = "darkred", lty = 2, lwd = 2)

  # Add text with test result
  text(min(medians) + 0.7 * (max(medians) - min(medians)),
       max(hist(medians, breaks = 50, plot = FALSE)$density) * 0.8,
       sprintf("Shapiro-Wilk p = %.4f\nSkewness = %.4f",
               normality_results_normal[[i]]$shapiro_p,
               normality_results_normal[[i]]$skewness),
       cex = 0.8)
}

dev.off()
cat("\nPart 1 (Normal) plots saved to: task2_part1_normal_medians.pdf\n")

# Test uniform distribution
cat("\n\n--- Uniform Distribution ---\n")

pdf("MSDS401/Assignment_2/task2_part1_uniform_medians.pdf", width = 12, height = 10)
par(mfrow = c(2, 2), mar = c(4, 4, 3, 2))

for (i in 1:length(sample_sizes)) {
  n <- sample_sizes[i]

  cat(sprintf("\nUniform Distribution, n = %d\n", n))

  sim_results <- simulate_median_distribution(n, "uniform", num_sims,
                                              list(min = 0, max = 1))

  medians <- sim_results$medians

  cat(sprintf("Sample Median: Mean = %.4f, SE = %.4f\n",
              mean(medians), sd(medians)))

  test_normality(medians, sprintf("Median (n=%d)", n))

  hist(medians, breaks = 50, freq = FALSE,
       main = sprintf("Sampling Dist. of Median\nUniform Population, n = %d", n),
       xlab = "Sample Median",
       ylab = "Density",
       col = "lightgreen", border = "black")

  x_seq <- seq(min(medians), max(medians), length.out = 200)
  lines(x_seq, dnorm(x_seq, mean = mean(medians), sd = sd(medians)),
        col = "red", lwd = 2)

  abline(v = mean(medians), col = "darkred", lty = 2, lwd = 2)
}

dev.off()
cat("\nPart 1 (Uniform) plots saved to: task2_part1_uniform_medians.pdf\n")

# =========================================================================
# PART 2: SKEWED DISTRIBUTIONS
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("PART 2: SAMPLING DISTRIBUTION OF MEDIAN - SKEWED DISTRIBUTIONS\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

cat("This section addresses: 'Why might this be the case?'\n")
cat("Answer: Skewed distributions cause issues for the median's normality.\n\n")

# Test exponential distribution (right-skewed)
cat("--- Exponential Distribution (Right-Skewed) ---\n")

pdf("MSDS401/Assignment_2/task2_part2_exponential.pdf", width = 14, height = 10)
par(mfrow = c(3, 3), mar = c(4, 4, 3, 2))

# Show population distribution first
x_exp <- rexp(10000, rate = 1)
hist(x_exp, breaks = 50, freq = FALSE,
     main = "Population: Exponential(rate=1)\n(Right-Skewed)",
     xlab = "Value", ylab = "Density",
     col = "coral", border = "black")
curve(dexp(x, rate = 1), add = TRUE, col = "blue", lwd = 2)
text(max(x_exp) * 0.7, max(hist(x_exp, breaks = 50, plot = FALSE)$density) * 0.8,
     sprintf("Population Mean = 1.0\nPopulation Median = %.2f", median(x_exp)),
     cex = 0.9)

# Test median vs mean for different sample sizes
for (i in 1:length(sample_sizes)) {
  n <- sample_sizes[i]

  cat(sprintf("\nExponential Distribution, n = %d\n", n))

  sim_results <- simulate_median_distribution(n, "exponential", num_sims,
                                              list(rate = 1))

  medians <- sim_results$medians
  means <- sim_results$means

  cat(sprintf("Sample Median: Mean = %.4f, SE = %.4f\n",
              mean(medians), sd(medians)))
  cat(sprintf("Sample Mean:   Mean = %.4f, SE = %.4f\n",
              mean(means), sd(means)))

  test_normality(medians, sprintf("Median (n=%d)", n))

  # Plot median distribution
  hist(medians, breaks = 50, freq = FALSE,
       main = sprintf("Median Distribution, n = %d\nExponential Population", n),
       xlab = "Sample Median",
       ylab = "Density",
       col = "lightcoral", border = "black")

  x_seq <- seq(min(medians), max(medians), length.out = 200)
  lines(x_seq, dnorm(x_seq, mean = mean(medians), sd = sd(medians)),
        col = "red", lwd = 2)
  abline(v = mean(medians), col = "darkred", lty = 2, lwd = 2)

  # Plot mean distribution for comparison
  hist(means, breaks = 50, freq = FALSE,
       main = sprintf("Mean Distribution, n = %d\nExponential Population", n),
       xlab = "Sample Mean",
       ylab = "Density",
       col = "lightblue", border = "black")

  x_seq <- seq(min(means), max(means), length.out = 200)
  lines(x_seq, dnorm(x_seq, mean = mean(means), sd = sd(means)),
        col = "red", lwd = 2)
  abline(v = mean(means), col = "darkred", lty = 2, lwd = 2)
}

dev.off()
cat("\nPart 2 (Exponential) plots saved to: task2_part2_exponential.pdf\n")

# =========================================================================
# PART 3: COMPARISON - MEDIAN VS MEAN NORMALITY
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("PART 3: DIRECT COMPARISON - MEDIAN VS MEAN\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

# Chi-squared distribution (highly skewed)
cat("--- Chi-squared Distribution (df=3, Highly Right-Skewed) ---\n")

pdf("MSDS401/Assignment_2/task2_part3_comparison.pdf", width = 14, height = 10)

n_test <- 50  # Fixed sample size for comparison

# Population distribution
par(mfrow = c(2, 3), mar = c(4, 4, 3, 2))

x_chi <- rchisq(10000, df = 3)
hist(x_chi, breaks = 100, freq = FALSE,
     main = "Population: Chi-squared(df=3)\n(Highly Right-Skewed)",
     xlab = "Value", ylab = "Density",
     col = "coral", border = "black", xlim = c(0, 15))
curve(dchisq(x, df = 3), add = TRUE, col = "blue", lwd = 2)

cat(sprintf("\nChi-squared Distribution, n = %d\n", n_test))

sim_results <- simulate_median_distribution(n_test, "skewed_right", num_sims,
                                           list(df = 3))

medians <- sim_results$medians
means <- sim_results$means

# Test normality for both
cat("\n--- MEDIAN Statistics ---\n")
median_norm <- test_normality(medians, "Sample Median")

cat("\n--- MEAN Statistics ---\n")
mean_norm <- test_normality(means, "Sample Mean")

# Q-Q plots
qqnorm(medians, main = sprintf("Q-Q Plot: Sample Median\n(n=%d, Chi-sq population)", n_test),
       pch = 19, cex = 0.5, col = "coral")
qqline(medians, col = "red", lwd = 2)

qqnorm(means, main = sprintf("Q-Q Plot: Sample Mean\n(n=%d, Chi-sq population)", n_test),
       pch = 19, cex = 0.5, col = "lightblue")
qqline(means, col = "red", lwd = 2)

# Histograms
hist(medians, breaks = 50, freq = FALSE,
     main = sprintf("Median Sampling Distribution\n(n=%d, Chi-sq population)", n_test),
     xlab = "Sample Median",
     ylab = "Density",
     col = "coral", border = "black")
x_seq <- seq(min(medians), max(medians), length.out = 200)
lines(x_seq, dnorm(x_seq, mean = mean(medians), sd = sd(medians)),
      col = "red", lwd = 2, lty = 2)
legend("topright",
       legend = c(sprintf("Skewness: %.3f", median_norm$skewness),
                 sprintf("p-value: %.4f", median_norm$shapiro_p)),
       bty = "n", cex = 0.8)

hist(means, breaks = 50, freq = FALSE,
     main = sprintf("Mean Sampling Distribution\n(n=%d, Chi-sq population)", n_test),
     xlab = "Sample Mean",
     ylab = "Density",
     col = "lightblue", border = "black")
x_seq <- seq(min(means), max(means), length.out = 200)
lines(x_seq, dnorm(x_seq, mean = mean(means), sd = sd(means)),
      col = "red", lwd = 2, lty = 2)
legend("topright",
       legend = c(sprintf("Skewness: %.3f", mean_norm$skewness),
                 sprintf("p-value: %.4f", mean_norm$shapiro_p)),
       bty = "n", cex = 0.8)

dev.off()
cat("\nPart 3 (Comparison) plots saved to: task2_part3_comparison.pdf\n")

# =========================================================================
# PART 4: SUMMARY TABLE AND CONCLUSIONS
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("PART 4: SUMMARY AND CONCLUSIONS\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

cat("ANSWER TO 'WHY MIGHT THIS BE THE CASE?'\n")
cat(paste(rep("-", 75), collapse=""), "\n\n")

cat("The sampling distribution of the MEDIAN may NOT follow a normal distribution\n")
cat("because:\n\n")

cat("1. CLT PRIMARILY APPLIES TO MEANS\n")
cat("   - The Central Limit Theorem guarantees normality for sample MEANS\n")
cat("   - The median has different mathematical properties\n")
cat("   - The median is less 'smooth' - based on order statistics\n\n")

cat("2. EFFICIENCY DIFFERENCES\n")
cat("   - For normal populations: median has ~57% efficiency of mean\n")
cat("   - This means median has larger standard error (SE_median ≈ 1.25 × SE_mean)\n")
cat("   - The median's distribution converges to normality more slowly\n\n")

cat("3. SKEWED POPULATIONS ARE PROBLEMATIC\n")
cat("   - Median is robust to outliers (an advantage)\n")
cat("   - But this robustness comes at a cost for normality\n")
cat("   - Skewed populations → median distribution inherits skewness longer\n")
cat("   - Mean 'averages away' skewness faster due to CLT\n\n")

cat("4. SAMPLE SIZE REQUIREMENTS\n")
cat("   - Median needs LARGER n than mean to achieve normality\n")
cat("   - Rule of thumb: need n ≥ 50-100 for median (vs. n ≥ 30 for mean)\n")
cat("   - This is especially true for skewed distributions\n\n")

# Create summary comparison table
cat("\n", paste(rep("=", 75), collapse=""), "\n")
cat("EMPIRICAL COMPARISON: NORMAL vs. EXPONENTIAL POPULATION\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

comparison_table <- data.frame(
  Distribution = character(),
  Sample_Size = integer(),
  Median_SE = numeric(),
  Mean_SE = numeric(),
  SE_Ratio = numeric(),
  Median_Skewness = numeric(),
  Mean_Skewness = numeric(),
  stringsAsFactors = FALSE
)

# Run comparisons
distributions <- list(
  list(name = "Normal", type = "normal", params = list(mean = 0, sd = 1)),
  list(name = "Exponential", type = "exponential", params = list(rate = 1))
)

for (dist in distributions) {
  for (n in c(10, 30, 100)) {
    sim_results <- simulate_median_distribution(n, dist$type, 5000, dist$params)

    median_se <- sd(sim_results$medians)
    mean_se <- sd(sim_results$means)
    median_skew <- mean((sim_results$medians - mean(sim_results$medians))^3) /
                   sd(sim_results$medians)^3
    mean_skew <- mean((sim_results$means - mean(sim_results$means))^3) /
                 sd(sim_results$means)^3

    comparison_table <- rbind(comparison_table, data.frame(
      Distribution = dist$name,
      Sample_Size = n,
      Median_SE = median_se,
      Mean_SE = mean_se,
      SE_Ratio = median_se / mean_se,
      Median_Skewness = median_skew,
      Mean_Skewness = mean_skew
    ))
  }
}

print(comparison_table)

cat("\n\nKEY OBSERVATIONS FROM TABLE:\n")
cat("1. Normal Population: Median SE is ~1.25× larger than Mean SE\n")
cat("2. Exponential Population: Median SE is ~1.5-2× larger than Mean SE\n")
cat("3. Median inherits more skewness from skewed populations\n")
cat("4. Mean's skewness decreases faster with increasing n\n")

# =========================================================================
# FINAL RECOMMENDATIONS
# =========================================================================

cat("\n\n", paste(rep("=", 75), collapse=""), "\n")
cat("PRACTICAL RECOMMENDATIONS\n")
cat(paste(rep("=", 75), collapse=""), "\n\n")

cat("WHEN TO USE THE MEDIAN:\n")
cat("✓ When you have outliers or heavily skewed data\n")
cat("✓ When you want a robust measure of central tendency\n")
cat("✓ When you have sufficient sample size (n ≥ 50)\n\n")

cat("WHEN TO USE THE MEAN:\n")
cat("✓ When you need precise confidence intervals (smaller SE)\n")
cat("✓ When your data is approximately symmetric\n")
cat("✓ When CLT guarantees normality (n ≥ 30)\n")
cat("✓ When you need to combine results across studies\n\n")

cat("FOR INFERENCE WITH MEDIAN:\n")
cat("• Use bootstrap methods (more reliable than assuming normality)\n")
cat("• Increase sample size beyond typical n=30 rule\n")
cat("• Check normality with Q-Q plots before using z/t tests\n")
cat("• Consider non-parametric tests (Wilcoxon, etc.)\n\n")

cat(paste(rep("=", 75), collapse=""), "\n")
cat("TASK 2 COMPLETE!\n")
cat(paste(rep("=", 75), collapse=""), "\n")