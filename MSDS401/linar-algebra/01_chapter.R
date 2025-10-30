# Your actual data
data <- c(23, 25, 28, 24, 26, 89, 27, 25, 29, 24)  # Notice the 89

# Could normal data produce this outlier?
fake_normal <- replicate(1000, {
  max(rnorm(10, mean=mean(data), sd=sd(data)))
})

# Where does our outlier rank?
mean(fake_normal >= max(data))  # If < 5%, normal is incompatible



# Observed: customer spent $75
purchase <- 75

# Two customer types (like two cookie bowls)
# Premium customers: mean=$100, sd=$20
# Regular customers: mean=$50, sd=$15

# Prior: 30% are premium, 70% regular
prior_premium <- 0.30
prior_regular <- 0.70

# Likelihood: how probable is $75 from each type?
likelihood_premium <- dnorm(purchase, mean=100, sd=20)
likelihood_regular <- dnorm(purchase, mean=50, sd=15)

# Bayes theorem
posterior_premium <- (likelihood_premium * prior_premium) /
  (likelihood_premium * prior_premium + likelihood_regular * prior_regular)

cat("Probability this is a premium customer:", round(posterior_premium, 3))



# Claimed: response times follow exponential (constant failure rate)
observed_times <- c(1, 2, 1.5, 2.5, 8, 9, 10, 11, 12)  # Times increase!

# Test: plot observed vs what exponential predicts
fake_exponential <- rexp(100, rate=1/mean(observed_times))

hist(fake_exponential, col=rgb(0,0,1,0.3), main="Blue=Model, Red=Reality")
hist(observed_times, col=rgb(1,0,0,0.3), add=TRUE)


# Observed data
clicks_A <- 45;  visitors_A <- 1000
clicks_B <- 62;  visitors_B <- 1000

# Bayesian posterior (Beta distribution)
theta_A <- rbeta(10000, 1 + clicks_A, 1 + visitors_A - clicks_A)
theta_B <- rbeta(10000, 1 + clicks_B, 1 + visitors_B - clicks_B)

# Probability B is better
prob_B_wins <- mean(theta_B > theta_A)
expected_lift <- median((theta_B - theta_A) / theta_A) * 100

cat("P(B better than A):", round(prob_B_wins, 3), "\n")
cat("Expected lift:", round(expected_lift, 1), "%")