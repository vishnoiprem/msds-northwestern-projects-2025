# Assignment 2 - Task 1: Central Limit Theorem for Sample Proportions
# =========================================================================
# Using Base R Graphics (No External Packages Required)

# Set seed for reproducibility
set.seed(123)

# Function to simulate sampling distribution of sample proportion
simulate_sampling_distribution <- function(n, p, num_simulations = 10000) {
  sample_proportions <- numeric(num_simulations)
  for (i in 1:num_simulations) {
    sample <- rbinom(n, size = 1, prob = p)
    sample_proportions[i] <- mean(sample)
  }
  return(sample_proportions)
}

# =========================================================================
# SIMULATION PARAMETERS
# =========================================================================
sample_sizes <- c(10, 30, 100, 250)
pop_proportions <- c(0.1, 0.3, 0.5, 0.7, 0.9)
num_sims <- 10000

# =========================================================================
# PART A: EFFECT OF SAMPLE SIZE (using p = 0.5)
# =========================================================================

cat(paste(rep("=", 70), collapse=""), "\n")
cat("PART A: Effect of Sample Size on Sampling Distribution\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

p_fixed <- 0.5

# Save plots to PDF
pdf("MSDS401/Assignment_2/task1_part_a_plots.pdf", width = 12, height = 10)


par(mfrow = c(2, 2), mar = c(4, 4, 3, 2))

for (i in 1:length(sample_sizes)) {
  n <- sample_sizes[i]
  p_hats <- simulate_sampling_distribution(n, p_fixed, num_sims)

  theoretical_mean <- p_fixed
  theoretical_se <- sqrt(p_fixed * (1 - p_fixed) / n)
  sample_mean <- mean(p_hats)
  sample_se <- sd(p_hats)

  cat(sprintf("Sample Size n = %d:\n", n))
  cat(sprintf("  Theoretical Mean: %.4f | Sample Mean: %.4f\n",
              theoretical_mean, sample_mean))
  cat(sprintf("  Theoretical SE:   %.4f | Sample SE:   %.4f\n",
              theoretical_se, sample_se))
  cat(sprintf("  Difference in SE: %.4f (%.2f%%)\n\n",
              abs(theoretical_se - sample_se),
              abs(theoretical_se - sample_se) / theoretical_se * 100))

  # Create histogram
  hist(p_hats, breaks = 50, freq = FALSE,
       main = sprintf("n = %d (p = %.1f)", n, p_fixed),
       xlab = "Sample Proportion (p-hat)",
       ylab = "Density",
       col = "lightblue", border = "black")

  # Add theoretical normal curve
  x_seq <- seq(min(p_hats), max(p_hats), length.out = 200)
  lines(x_seq, dnorm(x_seq, mean = theoretical_mean, sd = theoretical_se),
        col = "red", lwd = 2)

  # Add vertical line at mean
  abline(v = theoretical_mean, col = "darkred", lty = 2, lwd = 2)

  # Add legend
  legend("topright",
         legend = c("Simulated", "Theoretical Normal", "True p"),
         col = c("lightblue", "red", "darkred"),
         lty = c(1, 1, 2), lwd = c(10, 2, 2), bty = "n", cex = 0.8)
}

dev.off()
cat("Part A plots saved to: task1_part_a_plots.pdf\n\n")

# =========================================================================
# PART B: EFFECT OF POPULATION PROPORTION P (using n = 100)
# =========================================================================

cat("\n", paste(rep("=", 70), collapse=""), "\n")
cat("PART B: Effect of Population Proportion P\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

n_fixed <- 100

pdf("MSDS401/Assignment_2/task1_part_b_plots.pdf", width = 15, height = 10)
par(mfrow = c(2, 3), mar = c(4, 4, 3, 2))

for (i in 1:length(pop_proportions)) {
  p <- pop_proportions[i]
  p_hats <- simulate_sampling_distribution(n_fixed, p, num_sims)

  theoretical_mean <- p
  theoretical_se <- sqrt(p * (1 - p) / n_fixed)
  sample_mean <- mean(p_hats)
  sample_se <- sd(p_hats)

  cat(sprintf("Population Proportion p = %.1f:\n", p))
  cat(sprintf("  Theoretical Mean: %.4f | Sample Mean: %.4f\n",
              theoretical_mean, sample_mean))
  cat(sprintf("  Theoretical SE:   %.4f | Sample SE:   %.4f\n",
              theoretical_se, sample_se))
  cat(sprintf("  Difference in SE: %.4f (%.2f%%)\n\n",
              abs(theoretical_se - sample_se),
              abs(theoretical_se - sample_se) / theoretical_se * 100))

  # Create histogram
  hist(p_hats, breaks = 50, freq = FALSE,
       main = sprintf("p = %.1f (n = %d)", p, n_fixed),
       xlab = "Sample Proportion (p-hat)",
       ylab = "Density",
       col = "lightgreen", border = "black")

  # Add theoretical normal curve
  x_seq <- seq(max(0, p - 4*theoretical_se),
               min(1, p + 4*theoretical_se),
               length.out = 200)
  lines(x_seq, dnorm(x_seq, mean = theoretical_mean, sd = theoretical_se),
        col = "red", lwd = 2)

  abline(v = theoretical_mean, col = "darkred", lty = 2, lwd = 2)

  legend("topright",
         legend = c("Simulated", "Theoretical", "True p"),
         col = c("lightgreen", "red", "darkred"),
         lty = c(1, 1, 2), lwd = c(10, 2, 2), bty = "n", cex = 0.7)
}

dev.off()
cat("Part B plots saved to: task1_part_b_plots.pdf\n\n")

# =========================================================================
# PART C: STANDARD ERRORS COMPARISON
# =========================================================================

cat("\n", paste(rep("=", 70), collapse=""), "\n")
cat("PART C: Standard Errors - Theory vs. Simulation\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

# Create comparison data
test_scenarios <- expand.grid(n = sample_sizes, p = c(0.3, 0.5, 0.7))
comparison_results <- data.frame(
  n = integer(),
  p = numeric(),
  SE_Theoretical = numeric(),
  SE_Simulated = numeric(),
  Abs_Diff = numeric(),
  Pct_Diff = numeric()
)

for (i in 1:nrow(test_scenarios)) {
  n <- test_scenarios$n[i]
  p <- test_scenarios$p[i]

  p_hats <- simulate_sampling_distribution(n, p, num_sims)
  se_theoretical <- sqrt(p * (1 - p) / n)
  se_simulated <- sd(p_hats)
  abs_diff <- abs(se_theoretical - se_simulated)
  pct_diff <- (abs_diff / se_theoretical) * 100

  comparison_results <- rbind(comparison_results, data.frame(
    n = n,
    p = p,
    SE_Theoretical = se_theoretical,
    SE_Simulated = se_simulated,
    Abs_Diff = abs_diff,
    Pct_Diff = pct_diff
  ))
}

print(comparison_results)

# Create comparison plot
pdf("MSDS401/Assignment_2/task1_part_c_comparison.pdf", width = 10, height = 8)
plot(comparison_results$SE_Theoretical, comparison_results$SE_Simulated,
     pch = 19, cex = 2,
     col = rainbow(length(sample_sizes))[as.factor(comparison_results$n)],
     main = "Standard Error: Theoretical vs. Simulated",
     xlab = "Theoretical Standard Error",
     ylab = "Simulated Standard Error",
     xlim = c(0, max(comparison_results$SE_Theoretical) * 1.1),
     ylim = c(0, max(comparison_results$SE_Simulated) * 1.1))

abline(a = 0, b = 1, lty = 2, col = "red", lwd = 2)
legend("topleft",
       legend = paste("n =", unique(comparison_results$n)),
       col = rainbow(length(sample_sizes)),
       pch = 19, cex = 1, bty = "n")

text(max(comparison_results$SE_Theoretical) * 0.7,
     max(comparison_results$SE_Simulated) * 0.2,
     "Points on the diagonal\nindicate perfect agreement",
     col = "darkred", cex = 0.9)

dev.off()
cat("\nPart C comparison plot saved to: task1_part_c_comparison.pdf\n\n")

# =========================================================================
# PART D: PRACTICAL IMPLICATIONS
# =========================================================================

cat("\n", paste(rep("=", 70), collapse=""), "\n")
cat("PART D: Practical Implications for Real Data Sampling\n")
cat(paste(rep("=", 70), collapse=""), "\n\n")

cat("KEY PRACTICAL INSIGHTS:\n")
cat(paste(rep("-", 70), collapse=""), "\n\n")

cat("1. SAMPLE SIZE REQUIREMENTS:\n")
cat("   - Minimum n=30 often cited as 'rule of thumb' for CLT\n")
cat("   - Our simulations show even n=10 works reasonably well for p near 0.5\n")
cat("   - For extreme p values (close to 0 or 1), larger samples needed\n")
cat("   - Rule: np >= 10 AND n(1-p) >= 10 for good normal approximation\n\n")

cat("2. EFFECT OF POPULATION PROPORTION:\n")
cat("   - Standard error is MAXIMIZED when p = 0.5\n")
cat("   - Standard error decreases as p approaches 0 or 1\n")
cat("   - When planning studies with unknown p, use p = 0.5 for\n")
cat("     conservative (worst-case) sample size estimates\n\n")

cat("3. STANDARD ERROR BEHAVIOR:\n")
cat("   - SE decreases with sqrt(n), NOT linearly with n\n")
cat("   - To HALVE the SE, need to QUADRUPLE the sample size\n")
cat("   - To reduce SE by 10x, need to increase sample by 100x\n")
cat("   - This has major cost implications for survey design\n\n")

cat("4. REAL-WORLD APPLICATIONS:\n")
cat("   a) Political Polling:\n")
cat("      - Typical n=1000 gives SE ~ 0.016 (1.6 percentage points)\n")
cat("      - Explains why polls have 3-4% margin of error\n")
cat("      - Close races need larger samples for conclusive results\n\n")
cat("   b) Quality Control:\n")
cat("      - When defect rate p is very low (e.g., 0.01),\n")
cat("        need larger samples to detect issues\n")
cat("      - Can use smaller samples when p is near 0.5\n\n")
cat("   c) A/B Testing (Web/Marketing):\n")
cat("      - Sample size calculations critical before running tests\n")
cat("      - Small differences in conversion rates require\n")
cat("        very large samples to detect\n\n")
cat("   d) Survey Design:\n")
cat("      - Must balance precision (lower SE) vs. cost\n")
cat("      - Diminishing returns: going from n=100 to n=400\n")
cat("        only halves the SE but quadruples the cost\n\n")

cat("5. SUCCESS-FAILURE CONDITION VERIFICATION:\n")
cat("   Testing np >= 10 AND n(1-p) >= 10 rule:\n\n")

for (n in sample_sizes) {
  cat(sprintf("   Sample size n = %d:\n", n))
  for (p in c(0.1, 0.3, 0.5, 0.7, 0.9)) {
    success <- n * p
    failure <- n * (1 - p)
    meets_condition <- (success >= 10) & (failure >= 10)
    status <- ifelse(meets_condition, "PASS", "FAIL")
    cat(sprintf("      p=%.1f: np=%5.1f, n(1-p)=%5.1f -> %s\n",
                p, success, failure, status))
  }
  cat("\n")
}

cat(paste(rep("-", 70), collapse=""), "\n")
cat("\n6. SUMMARY RECOMMENDATIONS:\n")
cat("   - For most applications: aim for n >= 30\n")
cat("   - For binary outcomes: check np >= 10 and n(1-p) >= 10\n")
cat("   - For rare events (p < 0.1 or p > 0.9): use n >= 100\n")
cat("   - When in doubt, simulate! (as we did here)\n")
cat("   - Always report confidence intervals, not just point estimates\n\n")

cat(paste(rep("=", 70), collapse=""), "\n")
cat("TASK 1 COMPLETE! All results and plots saved.\n")
cat(paste(rep("=", 70), collapse=""), "\n")
