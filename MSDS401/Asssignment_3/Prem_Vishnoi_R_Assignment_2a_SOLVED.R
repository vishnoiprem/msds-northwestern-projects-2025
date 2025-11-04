# DO NOT ADD OR REVISE CODE HERE
knitr::opts_chunk$set(echo = TRUE, eval = TRUE)

library(moments)  # install.packages("moments")

n <- 100
p <- 0.05
lambda <- n * p  # lambda = 5 for Poisson approximation

# Poisson approximation
poisson_prob <- dpois(0, lambda)

# Exact binomial probability
binomial_prob <- dbinom(0, size = n, prob = p)

# Display results
cat("Poisson approximation: P(X = 0) =", round(poisson_prob, 6), "\n")
cat("Binomial exact: P(X = 0) =", round(binomial_prob, 6), "\n")


poisson_prob <- ppois(5, lambda, lower.tail = TRUE)

# Exact binomial probability
binomial_prob <- pbinom(5, size = n, prob = p, lower.tail = TRUE)

# Display results
cat("Poisson approximation: P(X < 6) =", round(poisson_prob, 6), "\n")
cat("Binomial exact: P(X < 6) =", round(binomial_prob, 6), "\n")


# Parameters for normal approximation
n <- 100
p <- 0.25
mu <- n * p  # mean = 25
sigma <- sqrt(n * p * (1 - p))  # standard deviation

# Normal approximation with continuity correction
# P(X = 25) ≈ P(24.5 < X < 25.5)
normal_prob <- pnorm(25.5, mean = mu, sd = sigma) - pnorm(24.5, mean = mu, sd = sigma)

# Exact binomial probability
binomial_prob <- dbinom(25, size = n, prob = p)

# Display results
cat("Normal approximation: P(X = 25) =", round(normal_prob, 6), "\n")
cat("Binomial exact: P(X = 25) =", round(binomial_prob, 6), "\n")


# P(X < 20) means P(X <= 19)
# With continuity correction: P(X <= 19.5)
normal_prob <- pnorm(19.5, mean = mu, sd = sigma, lower.tail = TRUE)

# Exact binomial probability
binomial_prob <- pbinom(19, size = n, prob = p, lower.tail = TRUE)

# Display results
cat("Normal approximation: P(X < 20) =", round(normal_prob, 6), "\n")
cat("Binomial exact: P(X < 20) =", round(binomial_prob, 6), "\n")



# Parameters
n <- 100
p <- 0.05
lambda <- n * p
outcomes <- 0:10

# Calculate probabilities
poisson_probs <- dpois(outcomes, lambda)
binomial_probs <- dbinom(outcomes, size = n, prob = p)

# Create side-by-side barplots
par(mfrow = c(1, 2))

barplot(poisson_probs, names.arg = outcomes, col = "steelblue",
        main = "Poisson Distribution\n(lambda = 5)",
        xlab = "Number of Successes", ylab = "Probability",
        ylim = c(0, max(c(poisson_probs, binomial_probs)) * 1.1))

barplot(binomial_probs, names.arg = outcomes, col = "coral",
        main = "Binomial Distribution\n(n = 100, p = 0.05)",
        xlab = "Number of Successes", ylab = "Probability",
        ylim = c(0, max(c(poisson_probs, binomial_probs)) * 1.1))

par(mfrow = c(1, 1))  # Reset plot layout