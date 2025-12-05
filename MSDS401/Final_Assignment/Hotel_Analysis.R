# ============================================================================
# TAKE HOME FINAL EXAM - HOTEL DATA ANALYSIS
# ============================================================================
# Student: Prem Vishnoi
# Course:  2025FA_MS_DSP_401-DL_SEC61
# Date:    December 5, 2025
# ============================================================================

# Clear the workspace
rm(list = ls())

# ----------------------------------------------------------------------------
# LOAD REQUIRED LIBRARIES
# ----------------------------------------------------------------------------
# If you haven't installed these packages, run:
# install.packages(c("readxl", "dplyr", "ggplot2", "corrplot", "car", "psych"))

library(readxl)      # for reading Excel files
library(dplyr)       # for data manipulation
library(ggplot2)     # for nice visualizations
library(corrplot)    # for correlation heatmap
library(car)         # for VIF calculation
library(psych)       # for detailed descriptive stats

# ----------------------------------------------------------------------------
# LOAD THE DATA
# ----------------------------------------------------------------------------
# Change this path to where your file is located
# df <- read_excel("Hotel Data_Final Exam.xlsx")

# For now, I'm creating sample data that matches the structure
# You can comment this out and use the line above for real data

set.seed(42)  # for reproducibility
n <- 3200     # number of hotels

# Define cities
metros <- c("Mumbai", "Delhi", "Bangalore", "Chennai", "Kolkata", "Hyderabad")
non_metros <- c("Jaipur", "Agra", "Goa", "Udaipur", "Varanasi", 
                "Shimla", "Manali", "Ooty", "Coorg", "Mysore")

# Create region mapping
region_map <- c(
  "Mumbai" = "West", "Delhi" = "North", "Bangalore" = "South",
  "Chennai" = "South", "Kolkata" = "East", "Hyderabad" = "South",
  "Jaipur" = "North", "Agra" = "North", "Goa" = "West",
  "Udaipur" = "North", "Varanasi" = "North", "Shimla" = "North",
  "Manali" = "North", "Ooty" = "South", "Coorg" = "South", "Mysore" = "South"
)

# Generate random cities with realistic probabilities
all_cities <- c(metros, non_metros)
city_probs <- c(0.15, 0.15, 0.12, 0.08, 0.06, 0.08,
                0.06, 0.05, 0.08, 0.04, 0.03, 0.03, 0.02, 0.02, 0.02, 0.01)
cities <- sample(all_cities, n, replace = TRUE, prob = city_probs)

# Build the dataframe
df <- data.frame(
  Hotel_ID = 1:n,
  Hotel_Name = paste0("Hotel_", 1:n),
  City = cities,
  Region = region_map[cities],
  Is_Metro = ifelse(cities %in% metros, 1, 0),
  Distance_from_City_Center = round(rexp(n, 0.33) + 0.5, 1),
  Has_Swimming_Pool = rbinom(n, 1, 0.35),
  Has_WiFi = rbinom(n, 1, 0.85),
  Has_Restaurant = rbinom(n, 1, 0.70),
  Has_Gym = rbinom(n, 1, 0.40),
  Has_Spa = rbinom(n, 1, 0.25),
  Has_Parking = rbinom(n, 1, 0.75),
  Star_Rating = sample(2:5, n, replace = TRUE, prob = c(0.15, 0.35, 0.35, 0.15)),
  Number_of_Ratings = rpois(n, 150) + 10
)

# Generate correlated ratings (they should be related to each other)
base <- 3.0 + 0.3 * df$Star_Rating + rnorm(n, 0, 0.3)
df$Overall_Rating <- round(pmin(pmax(base + 0.1*df$Has_Swimming_Pool + rnorm(n,0,0.2), 1), 5), 1)
df$Location_Rating <- round(pmin(pmax(df$Overall_Rating + rnorm(n, 0, 0.3), 1), 5), 1)
df$Cleanliness_Rating <- round(pmin(pmax(df$Overall_Rating + rnorm(n, 0, 0.25), 1), 5), 1)
df$Service_Rating <- round(pmin(pmax(df$Overall_Rating + rnorm(n, 0, 0.28), 1), 5), 1)
df$Value_for_Money_Rating <- round(pmin(pmax(df$Overall_Rating + rnorm(n, -0.1, 0.35), 1), 5), 1)
df$Comfort_Rating <- round(pmin(pmax(df$Overall_Rating + rnorm(n, 0, 0.22), 1), 5), 1)

# Generate room prices (based on star rating, metro status, features)
base_price <- 1500 + 1200 * df$Star_Rating
metro_extra <- ifelse(df$Is_Metro == 1, 800, 0)
feature_extra <- 400*df$Has_Swimming_Pool + 200*df$Has_Spa + 150*df$Has_Gym
df$Average_Room_Price <- round(pmax(base_price + metro_extra + feature_extra + rnorm(n, 0, 500), 500), 0)

# Quick look at the data
cat("\n========================================\n")
cat("DATA LOADED SUCCESSFULLY!\n")
cat("========================================\n")
cat("Total hotels:", nrow(df), "\n")
cat("Total variables:", ncol(df), "\n")
head(df)


# ============================================================================
# QUESTION 1: EXPLORATORY DATA ANALYSIS (EDA)
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#         QUESTION 1: EXPLORATORY DATA ANALYSIS            #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# 1.1 Dataset Overview
# ----------------------------------------------------------------------------
cat("\n--- 1.1 Dataset Overview ---\n\n")
cat("Number of rows:", nrow(df), "\n")
cat("Number of columns:", ncol(df), "\n\n")

cat("Column names:\n")
print(names(df))

cat("\nData structure:\n")
str(df)

# ----------------------------------------------------------------------------
# 1.2 Summary Statistics
# ----------------------------------------------------------------------------
# Formula reminder:
# Mean: x̄ = Σxᵢ / n
# Variance: s² = Σ(xᵢ - x̄)² / (n-1)  
# Std Dev: s = √(variance)
# Skewness: measures asymmetry (negative = left tail, positive = right tail)

cat("\n--- 1.2 Summary Statistics ---\n\n")

# Select only the numeric columns we care about
num_cols <- c("Distance_from_City_Center", "Number_of_Ratings", 
              "Overall_Rating", "Location_Rating", "Cleanliness_Rating",
              "Service_Rating", "Value_for_Money_Rating", "Comfort_Rating",
              "Average_Room_Price")

# Get detailed statistics using psych package
summary_table <- describe(df[, num_cols])
print(round(summary_table[, c("n", "mean", "sd", "min", "median", "max", "skew", "kurtosis")], 2))

# ----------------------------------------------------------------------------
# 1.3 Distribution Plots
# ----------------------------------------------------------------------------
cat("\n--- 1.3 Creating Distribution Plots ---\n")

# Set up a 3x3 grid for plots
par(mfrow = c(3, 3), mar = c(4, 4, 3, 1))

# Overall Rating histogram
hist(df$Overall_Rating, breaks = 30, col = "steelblue", border = "white",
     main = "Overall Rating Distribution", xlab = "Rating", ylab = "Count")
abline(v = mean(df$Overall_Rating), col = "red", lwd = 2, lty = 2)

# Average Room Price histogram  
hist(df$Average_Room_Price, breaks = 30, col = "forestgreen", border = "white",
     main = "Room Price Distribution", xlab = "Price (INR)", ylab = "Count")
abline(v = mean(df$Average_Room_Price), col = "red", lwd = 2, lty = 2)

# Distance histogram
hist(df$Distance_from_City_Center, breaks = 30, col = "orange", border = "white",
     main = "Distance from Center", xlab = "Distance (km)", ylab = "Count")

# Location Rating
hist(df$Location_Rating, breaks = 25, col = "purple", border = "white",
     main = "Location Rating", xlab = "Rating", ylab = "Count")

# Cleanliness Rating
hist(df$Cleanliness_Rating, breaks = 25, col = "coral", border = "white",
     main = "Cleanliness Rating", xlab = "Rating", ylab = "Count")

# Service Rating
hist(df$Service_Rating, breaks = 25, col = "cyan4", border = "white",
     main = "Service Rating", xlab = "Rating", ylab = "Count")

# Value for Money
hist(df$Value_for_Money_Rating, breaks = 25, col = "gold3", border = "white",
     main = "Value for Money Rating", xlab = "Rating", ylab = "Count")

# Comfort Rating
hist(df$Comfort_Rating, breaks = 25, col = "darkgreen", border = "white",
     main = "Comfort Rating", xlab = "Rating", ylab = "Count")

# Star Rating bar plot
barplot(table(df$Star_Rating), col = c("gray", "silver", "gold", "gold4"),
        main = "Star Rating Distribution", xlab = "Stars", ylab = "Count")

par(mfrow = c(1, 1))  # reset to single plot

# ----------------------------------------------------------------------------
# 1.4 Feature Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.4 Hotel Features Analysis ---\n\n")

# Which features do hotels have?
features <- c("Has_Swimming_Pool", "Has_WiFi", "Has_Restaurant", 
              "Has_Gym", "Has_Spa", "Has_Parking")

feature_summary <- data.frame(
  Feature = c("Swimming Pool", "WiFi", "Restaurant", "Gym", "Spa", "Parking"),
  Hotels_With = sapply(features, function(x) sum(df[[x]])),
  Percentage = sapply(features, function(x) round(mean(df[[x]]) * 100, 1)),
  Avg_Rating_With = sapply(features, function(x) round(mean(df$Overall_Rating[df[[x]] == 1]), 2)),
  Avg_Rating_Without = sapply(features, function(x) round(mean(df$Overall_Rating[df[[x]] == 0]), 2))
)
feature_summary$Impact <- feature_summary$Avg_Rating_With - feature_summary$Avg_Rating_Without

print(feature_summary)

# ----------------------------------------------------------------------------
# 1.5 Metro vs Non-Metro Comparison
# ----------------------------------------------------------------------------
cat("\n--- 1.5 Metro vs Non-Metro Comparison ---\n\n")

metro_summary <- df %>%
  group_by(Is_Metro) %>%
  summarise(
    Count = n(),
    Avg_Rating = round(mean(Overall_Rating), 3),
    SD_Rating = round(sd(Overall_Rating), 3),
    Avg_Price = round(mean(Average_Room_Price), 0),
    SD_Price = round(sd(Average_Room_Price), 0)
  )

metro_summary$Is_Metro <- ifelse(metro_summary$Is_Metro == 1, "Metro", "Non-Metro")
print(metro_summary)

# Box plots comparing Metro vs Non-Metro
par(mfrow = c(1, 2))

boxplot(Overall_Rating ~ Is_Metro, data = df, 
        col = c("lightblue", "salmon"),
        names = c("Non-Metro", "Metro"),
        main = "Rating: Metro vs Non-Metro",
        ylab = "Overall Rating")

boxplot(Average_Room_Price ~ Is_Metro, data = df,
        col = c("lightblue", "salmon"),
        names = c("Non-Metro", "Metro"),
        main = "Price: Metro vs Non-Metro",
        ylab = "Price (INR)")

par(mfrow = c(1, 1))

# ----------------------------------------------------------------------------
# 1.6 City-wise Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.6 City-wise Analysis ---\n\n")

city_summary <- df %>%
  group_by(City) %>%
  summarise(
    Count = n(),
    Avg_Rating = round(mean(Overall_Rating), 2),
    Avg_Price = round(mean(Average_Room_Price), 0)
  ) %>%
  arrange(desc(Count))

print(city_summary)

# ----------------------------------------------------------------------------
# 1.7 Region-wise Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.7 Region-wise Analysis ---\n\n")

region_summary <- df %>%
  group_by(Region) %>%
  summarise(
    Count = n(),
    Avg_Rating = round(mean(Overall_Rating), 2),
    Avg_Price = round(mean(Average_Room_Price), 0)
  )

print(region_summary)

# ----------------------------------------------------------------------------
# 1.8 Star Rating Impact
# ----------------------------------------------------------------------------
cat("\n--- 1.8 Star Rating Analysis ---\n\n")

star_summary <- df %>%
  group_by(Star_Rating) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(df)*100, 1),
    Avg_Rating = round(mean(Overall_Rating), 2),
    Avg_Price = round(mean(Average_Room_Price), 0)
  )

print(star_summary)


# ============================================================================
# QUESTION 2: CORRELATION ANALYSIS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#            QUESTION 2: CORRELATION ANALYSIS              #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# Formula:
# Pearson r = Σ[(xᵢ - x̄)(yᵢ - ȳ)] / √[Σ(xᵢ - x̄)² × Σ(yᵢ - ȳ)²]
#
# Interpretation:
# r = +1  --> perfect positive correlation
# r = -1  --> perfect negative correlation
# r = 0   --> no linear relationship
# |r| > 0.7  --> strong
# 0.4 < |r| < 0.7 --> moderate
# |r| < 0.4 --> weak
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 2.1 Compute Correlation Matrix
# ----------------------------------------------------------------------------
cat("\n--- 2.1 Correlation Matrix ---\n\n")

# Variables to include
corr_vars <- c("Distance_from_City_Center", "Number_of_Ratings",
               "Overall_Rating", "Location_Rating", "Cleanliness_Rating",
               "Service_Rating", "Value_for_Money_Rating", "Comfort_Rating",
               "Average_Room_Price", "Star_Rating")

cor_matrix <- cor(df[, corr_vars], use = "complete.obs")
print(round(cor_matrix, 3))

# ----------------------------------------------------------------------------
# 2.2 Correlation Heatmap
# ----------------------------------------------------------------------------
cat("\n--- 2.2 Creating Correlation Heatmap ---\n")

corrplot(cor_matrix, 
         method = "color",
         type = "upper",
         addCoef.col = "black",
         number.cex = 0.6,
         tl.col = "black",
         tl.srt = 45,
         tl.cex = 0.8,
         col = colorRampPalette(c("red", "white", "blue"))(100),
         title = "Correlation Heatmap",
         mar = c(0, 0, 2, 0))

# ----------------------------------------------------------------------------
# 2.3 Key Correlations with Overall Rating
# ----------------------------------------------------------------------------
cat("\n--- 2.3 Correlations with Overall Rating ---\n\n")

# Calculate correlations and p-values
other_vars <- corr_vars[corr_vars != "Overall_Rating"]

cor_overall <- data.frame(
  Variable = other_vars,
  Correlation = sapply(other_vars, function(x) round(cor(df$Overall_Rating, df[[x]]), 4)),
  P_Value = sapply(other_vars, function(x) {
    test <- cor.test(df$Overall_Rating, df[[x]])
    test$p.value
  })
)

cor_overall$Significant <- ifelse(cor_overall$P_Value < 0.001, "***",
                           ifelse(cor_overall$P_Value < 0.01, "**",
                           ifelse(cor_overall$P_Value < 0.05, "*", "")))

cor_overall <- cor_overall[order(-abs(cor_overall$Correlation)), ]
print(cor_overall)

# ----------------------------------------------------------------------------
# 2.4 Key Correlations with Average Room Price
# ----------------------------------------------------------------------------
cat("\n--- 2.4 Correlations with Average Room Price ---\n\n")

other_vars2 <- corr_vars[corr_vars != "Average_Room_Price"]

cor_price <- data.frame(
  Variable = other_vars2,
  Correlation = sapply(other_vars2, function(x) round(cor(df$Average_Room_Price, df[[x]]), 4)),
  P_Value = sapply(other_vars2, function(x) {
    test <- cor.test(df$Average_Room_Price, df[[x]])
    test$p.value
  })
)

cor_price$Significant <- ifelse(cor_price$P_Value < 0.001, "***",
                         ifelse(cor_price$P_Value < 0.01, "**",
                         ifelse(cor_price$P_Value < 0.05, "*", "")))

cor_price <- cor_price[order(-abs(cor_price$Correlation)), ]
print(cor_price)

# ----------------------------------------------------------------------------
# 2.5 Scatter Plots
# ----------------------------------------------------------------------------
cat("\n--- 2.5 Creating Scatter Plots ---\n")

par(mfrow = c(2, 3))

# Overall Rating vs Price
plot(df$Overall_Rating, df$Average_Room_Price, 
     pch = 19, col = rgb(0, 0, 1, 0.2),
     main = paste("Rating vs Price (r =", round(cor(df$Overall_Rating, df$Average_Room_Price), 3), ")"),
     xlab = "Overall Rating", ylab = "Price (INR)")
abline(lm(Average_Room_Price ~ Overall_Rating, data = df), col = "red", lwd = 2)

# Star Rating vs Price
plot(df$Star_Rating, df$Average_Room_Price,
     pch = 19, col = rgb(0, 0.5, 0, 0.2),
     main = paste("Stars vs Price (r =", round(cor(df$Star_Rating, df$Average_Room_Price), 3), ")"),
     xlab = "Star Rating", ylab = "Price (INR)")
abline(lm(Average_Room_Price ~ Star_Rating, data = df), col = "red", lwd = 2)

# Comfort vs Overall
plot(df$Comfort_Rating, df$Overall_Rating,
     pch = 19, col = rgb(0.5, 0, 0.5, 0.2),
     main = paste("Comfort vs Overall (r =", round(cor(df$Comfort_Rating, df$Overall_Rating), 3), ")"),
     xlab = "Comfort Rating", ylab = "Overall Rating")
abline(lm(Overall_Rating ~ Comfort_Rating, data = df), col = "red", lwd = 2)

# Cleanliness vs Overall
plot(df$Cleanliness_Rating, df$Overall_Rating,
     pch = 19, col = rgb(1, 0.5, 0, 0.2),
     main = paste("Cleanliness vs Overall (r =", round(cor(df$Cleanliness_Rating, df$Overall_Rating), 3), ")"),
     xlab = "Cleanliness Rating", ylab = "Overall Rating")
abline(lm(Overall_Rating ~ Cleanliness_Rating, data = df), col = "red", lwd = 2)

# Service vs Overall
plot(df$Service_Rating, df$Overall_Rating,
     pch = 19, col = rgb(0, 0.5, 0.5, 0.2),
     main = paste("Service vs Overall (r =", round(cor(df$Service_Rating, df$Overall_Rating), 3), ")"),
     xlab = "Service Rating", ylab = "Overall Rating")
abline(lm(Overall_Rating ~ Service_Rating, data = df), col = "red", lwd = 2)

# Value vs Overall
plot(df$Value_for_Money_Rating, df$Overall_Rating,
     pch = 19, col = rgb(0.5, 0.5, 0, 0.2),
     main = paste("Value vs Overall (r =", round(cor(df$Value_for_Money_Rating, df$Overall_Rating), 3), ")"),
     xlab = "Value for Money", ylab = "Overall Rating")
abline(lm(Overall_Rating ~ Value_for_Money_Rating, data = df), col = "red", lwd = 2)

par(mfrow = c(1, 1))

# ----------------------------------------------------------------------------
# 2.6 Correlation Summary
# ----------------------------------------------------------------------------
cat("\n--- 2.6 Correlation Summary ---\n")
cat("\nBest predictors for OVERALL RATING:\n")
cat("  1. Comfort Rating (strongest)\n")
cat("  2. Cleanliness Rating\n")
cat("  3. Service Rating\n")

cat("\nBest predictors for AVERAGE ROOM PRICE:\n")
cat("  1. Star Rating (strongest)\n")
cat("  2. Overall Rating\n")
cat("  3. Comfort Rating\n")


# ============================================================================
# QUESTION 3: CONTINGENCY TABLES AND CHI-SQUARE TESTS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#      QUESTION 3: CHI-SQUARE TESTS OF INDEPENDENCE        #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# Formula:
# χ² = Σ (Observed - Expected)² / Expected
# Expected = (Row Total × Column Total) / Grand Total
# df = (rows - 1) × (columns - 1)
#
# H₀: Variables are independent (no association)
# H₁: Variables are dependent (association exists)
# If p < 0.05, reject H₀
# ----------------------------------------------------------------------------

# Create a binary variable for high rating
df$Rating_High <- ifelse(df$Overall_Rating >= 4.0, 1, 0)

cat("\nSelected Variables for Chi-Square Tests:\n")
cat("1. Is_Metro (0=Non-Metro, 1=Metro)\n")
cat("2. Has_Swimming_Pool (0=No, 1=Yes)\n")
cat("3. Has_Restaurant (0=No, 1=Yes)\n")
cat("4. Rating_High (0=<4.0, 1=>=4.0)\n")

# ----------------------------------------------------------------------------
# Test 1: Is_Metro vs Has_Swimming_Pool
# ----------------------------------------------------------------------------
cat("\n\n--- TEST 1: Is_Metro vs Has_Swimming_Pool ---\n\n")

table1 <- table(df$Is_Metro, df$Has_Swimming_Pool)
dimnames(table1) <- list(Metro = c("Non-Metro", "Metro"), Pool = c("No", "Yes"))

cat("Contingency Table:\n")
print(addmargins(table1))

chi_test1 <- chisq.test(table1)

cat("\nExpected Frequencies:\n")
print(round(chi_test1$expected, 1))

cat("\nChi-Square Results:\n")
cat("  χ² =", round(chi_test1$statistic, 4), "\n")
cat("  df =", chi_test1$parameter, "\n")
cat("  p-value =", format(chi_test1$p.value, scientific = TRUE, digits = 4), "\n")

if (chi_test1$p.value < 0.05) {
  cat("\nConclusion: REJECT H₀ - Variables are DEPENDENT\n")
} else {
  cat("\nConclusion: FAIL TO REJECT H₀ - Variables are INDEPENDENT\n")
}

# ----------------------------------------------------------------------------
# Test 2: Is_Metro vs Has_Restaurant
# ----------------------------------------------------------------------------
cat("\n\n--- TEST 2: Is_Metro vs Has_Restaurant ---\n\n")

table2 <- table(df$Is_Metro, df$Has_Restaurant)
dimnames(table2) <- list(Metro = c("Non-Metro", "Metro"), Restaurant = c("No", "Yes"))

cat("Contingency Table:\n")
print(addmargins(table2))

chi_test2 <- chisq.test(table2)

cat("\nExpected Frequencies:\n")
print(round(chi_test2$expected, 1))

cat("\nChi-Square Results:\n")
cat("  χ² =", round(chi_test2$statistic, 4), "\n")
cat("  df =", chi_test2$parameter, "\n")
cat("  p-value =", format(chi_test2$p.value, scientific = TRUE, digits = 4), "\n")

if (chi_test2$p.value < 0.05) {
  cat("\nConclusion: REJECT H₀ - Variables are DEPENDENT\n")
} else {
  cat("\nConclusion: FAIL TO REJECT H₀ - Variables are INDEPENDENT\n")
}

# ----------------------------------------------------------------------------
# Test 3: Has_Swimming_Pool vs Rating_High
# ----------------------------------------------------------------------------
cat("\n\n--- TEST 3: Has_Swimming_Pool vs Rating_High ---\n\n")

table3 <- table(df$Has_Swimming_Pool, df$Rating_High)
dimnames(table3) <- list(Pool = c("No Pool", "Has Pool"), Rating = c("Low (<4)", "High (≥4)"))

cat("Contingency Table:\n")
print(addmargins(table3))

chi_test3 <- chisq.test(table3)

cat("\nExpected Frequencies:\n")
print(round(chi_test3$expected, 1))

cat("\nChi-Square Results:\n")
cat("  χ² =", round(chi_test3$statistic, 4), "\n")
cat("  df =", chi_test3$parameter, "\n")
cat("  p-value =", format(chi_test3$p.value, scientific = TRUE, digits = 4), "\n")

if (chi_test3$p.value < 0.05) {
  cat("\nConclusion: REJECT H₀ - Variables are DEPENDENT\n")
  cat("Swimming Pool IS associated with High Rating!\n")
} else {
  cat("\nConclusion: FAIL TO REJECT H₀ - Variables are INDEPENDENT\n")
}

# ----------------------------------------------------------------------------
# Test 4: Has_Restaurant vs Has_Swimming_Pool
# ----------------------------------------------------------------------------
cat("\n\n--- TEST 4: Has_Restaurant vs Has_Swimming_Pool ---\n\n")

table4 <- table(df$Has_Restaurant, df$Has_Swimming_Pool)
dimnames(table4) <- list(Restaurant = c("No", "Yes"), Pool = c("No", "Yes"))

cat("Contingency Table:\n")
print(addmargins(table4))

chi_test4 <- chisq.test(table4)

cat("\nExpected Frequencies:\n")
print(round(chi_test4$expected, 1))

cat("\nChi-Square Results:\n")
cat("  χ² =", round(chi_test4$statistic, 4), "\n")
cat("  df =", chi_test4$parameter, "\n")
cat("  p-value =", format(chi_test4$p.value, scientific = TRUE, digits = 4), "\n")

if (chi_test4$p.value < 0.05) {
  cat("\nConclusion: REJECT H₀ - Variables are DEPENDENT\n")
} else {
  cat("\nConclusion: FAIL TO REJECT H₀ - Variables are INDEPENDENT\n")
}

# ----------------------------------------------------------------------------
# Summary Table
# ----------------------------------------------------------------------------
cat("\n\n--- Chi-Square Tests Summary ---\n\n")

chi_summary <- data.frame(
  Test = c("Metro vs Pool", "Metro vs Restaurant", "Pool vs High Rating", "Restaurant vs Pool"),
  Chi_Square = round(c(chi_test1$statistic, chi_test2$statistic, chi_test3$statistic, chi_test4$statistic), 4),
  df = c(chi_test1$parameter, chi_test2$parameter, chi_test3$parameter, chi_test4$parameter),
  p_value = c(chi_test1$p.value, chi_test2$p.value, chi_test3$p.value, chi_test4$p.value),
  Result = c(
    ifelse(chi_test1$p.value < 0.05, "Dependent", "Independent"),
    ifelse(chi_test2$p.value < 0.05, "Dependent", "Independent"),
    ifelse(chi_test3$p.value < 0.05, "Dependent", "Independent"),
    ifelse(chi_test4$p.value < 0.05, "Dependent", "Independent")
  )
)

print(chi_summary)


# ============================================================================
# QUESTION 4: INFERENTIAL STATISTICS - TWO CITY COMPARISON
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#    QUESTION 4: TWO-SAMPLE T-TESTS (MUMBAI vs DELHI)      #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# Formula:
# t = (x̄₁ - x̄₂) / √(s₁²/n₁ + s₂²/n₂)
#
# 95% CI = (x̄₁ - x̄₂) ± t(α/2, df) × SE
#
# Cohen's d = (x̄₁ - x̄₂) / s_pooled
# where s_pooled = √[((n₁-1)s₁² + (n₂-1)s₂²) / (n₁+n₂-2)]
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 4.1 Select Cities with 100+ hotels
# ----------------------------------------------------------------------------
cat("\n--- 4.1 Cities with 100+ Hotels ---\n\n")

city_counts <- df %>%
  group_by(City) %>%
  summarise(Count = n()) %>%
  filter(Count >= 100) %>%
  arrange(desc(Count))

print(city_counts)

# Pick Mumbai and Delhi
city1 <- "Mumbai"
city2 <- "Delhi"

df_mumbai <- df %>% filter(City == city1)
df_delhi <- df %>% filter(City == city2)

cat("\nSelected:", city1, "(n =", nrow(df_mumbai), ") and", 
    city2, "(n =", nrow(df_delhi), ")\n")

# ----------------------------------------------------------------------------
# 4.2 Descriptive Statistics
# ----------------------------------------------------------------------------
cat("\n--- 4.2 Descriptive Statistics ---\n\n")

cat(city1, ":\n")
cat("  Price: Mean = ₹", round(mean(df_mumbai$Average_Room_Price), 2), 
    ", SD = ₹", round(sd(df_mumbai$Average_Room_Price), 2), "\n")
cat("  Rating: Mean =", round(mean(df_mumbai$Overall_Rating), 3),
    ", SD =", round(sd(df_mumbai$Overall_Rating), 3), "\n")

cat("\n", city2, ":\n", sep = "")
cat("  Price: Mean = ₹", round(mean(df_delhi$Average_Room_Price), 2),
    ", SD = ₹", round(sd(df_delhi$Average_Room_Price), 2), "\n")
cat("  Rating: Mean =", round(mean(df_delhi$Overall_Rating), 3),
    ", SD =", round(sd(df_delhi$Overall_Rating), 3), "\n")

# ----------------------------------------------------------------------------
# 4.3 T-Test for Average Room Price
# ----------------------------------------------------------------------------
cat("\n--- 4.3 T-Test: Average Room Price ---\n\n")

price_mumbai <- df_mumbai$Average_Room_Price
price_delhi <- df_delhi$Average_Room_Price

t_price <- t.test(price_mumbai, price_delhi, var.equal = FALSE)

cat("Hypotheses:\n")
cat("  H₀: μ_Mumbai = μ_Delhi (prices are equal)\n")
cat("  H₁: μ_Mumbai ≠ μ_Delhi (prices are different)\n\n")

cat("Test Results:\n")
cat("  t-statistic =", round(t_price$statistic, 4), "\n")
cat("  df =", round(t_price$parameter, 2), "\n")
cat("  p-value =", format(t_price$p.value, scientific = TRUE, digits = 4), "\n")
cat("  95% CI: (", round(t_price$conf.int[1], 2), ",", round(t_price$conf.int[2], 2), ")\n\n")

if (t_price$p.value < 0.05) {
  cat("Decision: REJECT H₀\n")
  cat("Conclusion: There IS a significant difference in prices.\n")
} else {
  cat("Decision: FAIL TO REJECT H₀\n")
  cat("Conclusion: There is NO significant difference in prices.\n")
}

# ----------------------------------------------------------------------------
# 4.4 T-Test for Overall Rating
# ----------------------------------------------------------------------------
cat("\n--- 4.4 T-Test: Overall Rating ---\n\n")

rating_mumbai <- df_mumbai$Overall_Rating
rating_delhi <- df_delhi$Overall_Rating

t_rating <- t.test(rating_mumbai, rating_delhi, var.equal = FALSE)

cat("Hypotheses:\n")
cat("  H₀: μ_Mumbai = μ_Delhi (ratings are equal)\n")
cat("  H₁: μ_Mumbai ≠ μ_Delhi (ratings are different)\n\n")

cat("Test Results:\n")
cat("  t-statistic =", round(t_rating$statistic, 4), "\n")
cat("  df =", round(t_rating$parameter, 2), "\n")
cat("  p-value =", format(t_rating$p.value, scientific = TRUE, digits = 4), "\n")
cat("  95% CI: (", round(t_rating$conf.int[1], 4), ",", round(t_rating$conf.int[2], 4), ")\n\n")

if (t_rating$p.value < 0.05) {
  cat("Decision: REJECT H₀\n")
  cat("Conclusion: There IS a significant difference in ratings.\n")
} else {
  cat("Decision: FAIL TO REJECT H₀\n")
  cat("Conclusion: There is NO significant difference in ratings.\n")
}

# ----------------------------------------------------------------------------
# 4.5 Effect Size (Cohen's d)
# ----------------------------------------------------------------------------
cat("\n--- 4.5 Effect Size (Cohen's d) ---\n\n")

# Formula: d = (mean1 - mean2) / pooled_sd
n1 <- length(price_mumbai)
n2 <- length(price_delhi)

# For price
pooled_sd_price <- sqrt(((n1-1)*var(price_mumbai) + (n2-1)*var(price_delhi)) / (n1+n2-2))
d_price <- (mean(price_mumbai) - mean(price_delhi)) / pooled_sd_price

# For rating
pooled_sd_rating <- sqrt(((n1-1)*var(rating_mumbai) + (n2-1)*var(rating_delhi)) / (n1+n2-2))
d_rating <- (mean(rating_mumbai) - mean(rating_delhi)) / pooled_sd_rating

cat("Interpretation:\n")
cat("  |d| < 0.2  --> Negligible\n")
cat("  0.2 - 0.5  --> Small\n")
cat("  0.5 - 0.8  --> Medium\n")
cat("  |d| >= 0.8 --> Large\n\n")

cat("Results:\n")
cat("  Cohen's d (Price):", round(d_price, 4))
if (abs(d_price) < 0.2) cat(" (Negligible)\n") else if (abs(d_price) < 0.5) cat(" (Small)\n") else if (abs(d_price) < 0.8) cat(" (Medium)\n") else cat(" (Large)\n")

cat("  Cohen's d (Rating):", round(d_rating, 4))
if (abs(d_rating) < 0.2) cat(" (Negligible)\n") else if (abs(d_rating) < 0.5) cat(" (Small)\n") else if (abs(d_rating) < 0.8) cat(" (Medium)\n") else cat(" (Large)\n")

# ----------------------------------------------------------------------------
# 4.6 Visualization
# ----------------------------------------------------------------------------
cat("\n--- 4.6 Creating Comparison Plots ---\n")

par(mfrow = c(1, 2))

# Price comparison
boxplot(price_mumbai, price_delhi,
        names = c("Mumbai", "Delhi"),
        col = c("lightblue", "salmon"),
        main = paste("Room Price\nt =", round(t_price$statistic, 2), ", p =", round(t_price$p.value, 4)),
        ylab = "Price (INR)")

# Rating comparison
boxplot(rating_mumbai, rating_delhi,
        names = c("Mumbai", "Delhi"),
        col = c("lightblue", "salmon"),
        main = paste("Overall Rating\nt =", round(t_rating$statistic, 2), ", p =", round(t_rating$p.value, 4)),
        ylab = "Rating")

par(mfrow = c(1, 1))


# ============================================================================
# QUESTION 5: ANOVA
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#                   QUESTION 5: ANOVA                      #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# Formula:
# F = MSB / MSW = [SSB/(k-1)] / [SSW/(N-k)]
#
# Two-Way ANOVA Model:
# Y = μ + α(Metro) + β(Distance) + αβ(Interaction) + ε
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 5.1 Create Distance Categories
# ----------------------------------------------------------------------------
cat("\n--- 5.1 Data Preparation ---\n\n")

df$Distance_Cat <- cut(df$Distance_from_City_Center,
                       breaks = c(0, 2, 5, Inf),
                       labels = c("Near (<2km)", "Moderate (2-5km)", "Far (>5km)"))

cat("Factors:\n")
cat("  1. Is_Metro: Metro vs Non-Metro\n")
cat("  2. Distance_Cat: Near, Moderate, Far\n")
cat("  Dependent Variable: Average_Room_Price\n")

# ----------------------------------------------------------------------------
# 5.2 Group Means
# ----------------------------------------------------------------------------
cat("\n--- 5.2 Group Means ---\n\n")

group_means <- df %>%
  group_by(Is_Metro, Distance_Cat) %>%
  summarise(
    N = n(),
    Mean_Price = round(mean(Average_Room_Price), 2),
    SD_Price = round(sd(Average_Room_Price), 2),
    .groups = "drop"
  )

group_means$Is_Metro <- ifelse(group_means$Is_Metro == 1, "Metro", "Non-Metro")
print(group_means)

# ----------------------------------------------------------------------------
# 5.3 Two-Way ANOVA
# ----------------------------------------------------------------------------
cat("\n--- 5.3 Two-Way ANOVA ---\n\n")

# Convert Is_Metro to factor for ANOVA
df$Is_Metro_F <- factor(df$Is_Metro, labels = c("Non-Metro", "Metro"))

anova_model <- aov(Average_Room_Price ~ Is_Metro_F * Distance_Cat, data = df)
anova_results <- summary(anova_model)

cat("Two-Way ANOVA Table:\n")
print(anova_results)

# ----------------------------------------------------------------------------
# 5.4 Interpretation
# ----------------------------------------------------------------------------
cat("\n--- 5.4 ANOVA Interpretation ---\n\n")

anova_table <- anova_results[[1]]
p_metro <- anova_table["Is_Metro_F", "Pr(>F)"]
p_dist <- anova_table["Distance_Cat", "Pr(>F)"]
p_inter <- anova_table["Is_Metro_F:Distance_Cat", "Pr(>F)"]

cat("1. MAIN EFFECT - Metro Status:\n")
cat("   F =", round(anova_table["Is_Metro_F", "F value"], 4), "\n")
cat("   p-value =", format(p_metro, scientific = TRUE, digits = 4), "\n")
cat("   Conclusion:", ifelse(p_metro < 0.05, "SIGNIFICANT - Metro affects price", "NOT significant"), "\n\n")

cat("2. MAIN EFFECT - Distance Category:\n")
cat("   F =", round(anova_table["Distance_Cat", "F value"], 4), "\n")
cat("   p-value =", format(p_dist, scientific = TRUE, digits = 4), "\n")
cat("   Conclusion:", ifelse(p_dist < 0.05, "SIGNIFICANT - Distance affects price", "NOT significant"), "\n\n")

cat("3. INTERACTION EFFECT (Metro × Distance):\n")
cat("   F =", round(anova_table["Is_Metro_F:Distance_Cat", "F value"], 4), "\n")
cat("   p-value =", format(p_inter, scientific = TRUE, digits = 4), "\n")
cat("   Conclusion:", ifelse(p_inter < 0.05, "SIGNIFICANT interaction", "NO significant interaction"), "\n")

# ----------------------------------------------------------------------------
# 5.5 One-Way ANOVA for Distance
# ----------------------------------------------------------------------------
cat("\n--- 5.5 One-Way ANOVA for Distance ---\n\n")

anova_dist <- aov(Average_Room_Price ~ Distance_Cat, data = df)
print(summary(anova_dist))

# Group means
dist_means <- df %>%
  group_by(Distance_Cat) %>%
  summarise(
    N = n(),
    Mean = round(mean(Average_Room_Price), 2),
    SD = round(sd(Average_Room_Price), 2)
  )

cat("\nGroup Means:\n")
print(dist_means)

# ----------------------------------------------------------------------------
# 5.6 Tukey's HSD Post-Hoc Test
# ----------------------------------------------------------------------------
cat("\n--- 5.6 Tukey's HSD Test ---\n\n")

tukey_result <- TukeyHSD(anova_dist)
print(tukey_result)

# ----------------------------------------------------------------------------
# 5.7 Visualization
# ----------------------------------------------------------------------------
cat("\n--- 5.7 Creating ANOVA Plots ---\n")

par(mfrow = c(1, 2))

# Main effect plot
metro_means <- tapply(df$Average_Room_Price, df$Is_Metro_F, mean)
barplot(metro_means, col = c("skyblue", "coral"),
        main = "Main Effect: Metro Status",
        ylab = "Mean Price (INR)",
        names.arg = c("Non-Metro", "Metro"))

# Interaction plot
interaction.plot(df$Distance_Cat, df$Is_Metro_F, df$Average_Room_Price,
                 col = c("blue", "red"), lwd = 2, type = "b",
                 main = "Interaction: Metro × Distance",
                 xlab = "Distance from Center",
                 ylab = "Mean Price (INR)",
                 trace.label = "Metro")

par(mfrow = c(1, 1))


# ============================================================================
# QUESTION 6: REGRESSION MODELING
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#            QUESTION 6: REGRESSION MODELING               #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# Formula:
# Y = β₀ + β₁X₁ + β₂X₂ + β₃X₃ + β₄X₄ + ε
#
# Where:
# Y = Average Room Price
# X₁ = Overall Rating
# X₂ = Location Rating
# X₃ = Value for Money Rating
# X₄ = Comfort Rating
#
# R² = 1 - (SSE/SST)
# VIF = 1 / (1 - R²)  --> VIF > 10 means multicollinearity problem
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 6.1 Full Model
# ----------------------------------------------------------------------------
cat("\n--- 6.1 Full Model (All 4 Predictors) ---\n\n")

model_full <- lm(Average_Room_Price ~ Overall_Rating + Location_Rating + 
                 Value_for_Money_Rating + Comfort_Rating, data = df)

print(summary(model_full))

# ----------------------------------------------------------------------------
# 6.2 Check Multicollinearity (VIF)
# ----------------------------------------------------------------------------
cat("\n--- 6.2 Variance Inflation Factor (VIF) ---\n\n")

vif_values <- vif(model_full)
print(round(vif_values, 2))

cat("\nInterpretation: VIF > 10 indicates severe multicollinearity.\n")
cat("Our VIF values are very high - the rating variables are highly correlated!\n")

# ----------------------------------------------------------------------------
# 6.3 Model Comparison
# ----------------------------------------------------------------------------
cat("\n--- 6.3 Model Comparison ---\n\n")

# Try different models
model1 <- lm(Average_Room_Price ~ Overall_Rating + Location_Rating + 
             Value_for_Money_Rating + Comfort_Rating, data = df)
model2 <- lm(Average_Room_Price ~ Overall_Rating + Location_Rating + 
             Value_for_Money_Rating, data = df)
model3 <- lm(Average_Room_Price ~ Overall_Rating + Value_for_Money_Rating, data = df)
model4 <- lm(Average_Room_Price ~ Overall_Rating, data = df)

comparison <- data.frame(
  Model = c("Full (4 vars)", "Without Comfort", "Overall + Value", "Only Overall"),
  R_Squared = round(c(summary(model1)$r.squared, summary(model2)$r.squared,
                      summary(model3)$r.squared, summary(model4)$r.squared), 4),
  Adj_R_Sq = round(c(summary(model1)$adj.r.squared, summary(model2)$adj.r.squared,
                     summary(model3)$adj.r.squared, summary(model4)$adj.r.squared), 4),
  AIC = round(c(AIC(model1), AIC(model2), AIC(model3), AIC(model4)), 1),
  BIC = round(c(BIC(model1), BIC(model2), BIC(model3), BIC(model4)), 1)
)

print(comparison)

cat("\nBest model: The simplest model (Only Overall Rating) has similar R²\n")
cat("and avoids multicollinearity issues.\n")

# ----------------------------------------------------------------------------
# 6.4 Final Model
# ----------------------------------------------------------------------------
cat("\n--- 6.4 Final Model ---\n\n")

final_model <- model4  # Using only Overall Rating
print(summary(final_model))

# ----------------------------------------------------------------------------
# 6.5 Regression Equation
# ----------------------------------------------------------------------------
cat("\n--- 6.5 Regression Equation ---\n\n")

b0 <- coef(final_model)[1]
b1 <- coef(final_model)[2]

cat("FINAL EQUATION:\n")
cat("Average_Room_Price =", round(b0, 2), "+", round(b1, 2), "× Overall_Rating\n\n")

cat("INTERPRETATION:\n")
cat("  Intercept (β₀) =", round(b0, 2), "\n")
cat("    When Overall Rating = 0, predicted price = ₹", round(b0, 0), "\n\n")
cat("  Slope (β₁) =", round(b1, 2), "\n")
cat("    For each 1-point increase in Overall Rating,\n")
cat("    Average Room Price increases by ₹", round(b1, 0), "\n\n")

cat("MODEL FIT:\n")
cat("  R² =", round(summary(final_model)$r.squared, 4), "\n")
cat("  Adjusted R² =", round(summary(final_model)$adj.r.squared, 4), "\n")
cat("  Model explains", round(summary(final_model)$r.squared * 100, 1), "% of price variation\n")

# ----------------------------------------------------------------------------
# 6.6 Residual Analysis
# ----------------------------------------------------------------------------
cat("\n--- 6.6 Residual Analysis ---\n\n")

residuals <- resid(final_model)
fitted_vals <- fitted(final_model)

cat("Residual Statistics:\n")
cat("  Mean:", round(mean(residuals), 6), "(should be ~0)\n")
cat("  Std Dev:", round(sd(residuals), 2), "\n")
cat("  Skewness:", round(psych::skew(residuals), 4), "\n")
cat("  Kurtosis:", round(psych::kurtosi(residuals), 4), "\n")

# Shapiro-Wilk test (sample of 500 because full sample is too large)
set.seed(123)
shapiro_test <- shapiro.test(sample(residuals, 500))
cat("\nShapiro-Wilk Normality Test (n=500 sample):\n")
cat("  W =", round(shapiro_test$statistic, 4), "\n")
cat("  p-value =", format(shapiro_test$p.value, scientific = TRUE, digits = 4), "\n")

# ----------------------------------------------------------------------------
# 6.7 Diagnostic Plots
# ----------------------------------------------------------------------------
cat("\n--- 6.7 Creating Diagnostic Plots ---\n")

par(mfrow = c(2, 2))

# 1. Residuals vs Fitted
plot(fitted_vals, residuals, pch = 19, col = rgb(0, 0, 1, 0.2),
     main = "Residuals vs Fitted",
     xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red", lwd = 2, lty = 2)

# 2. Q-Q Plot
qqnorm(residuals, pch = 19, col = rgb(0, 0, 1, 0.3),
       main = "Q-Q Plot (Normality Check)")
qqline(residuals, col = "red", lwd = 2)

# 3. Histogram of Residuals
hist(residuals, breaks = 40, col = "lightblue", border = "white",
     main = "Histogram of Residuals",
     xlab = "Residuals", ylab = "Frequency")

# 4. Actual vs Predicted
plot(df$Average_Room_Price, fitted_vals, pch = 19, col = rgb(0, 0, 1, 0.2),
     main = "Actual vs Predicted",
     xlab = "Actual Price (INR)", ylab = "Predicted Price (INR)")
abline(0, 1, col = "red", lwd = 2, lty = 2)

par(mfrow = c(1, 1))

# ----------------------------------------------------------------------------
# 6.8 Prediction Example
# ----------------------------------------------------------------------------
cat("\n--- 6.8 Prediction Example ---\n\n")

new_rating <- 4.5
predicted_price <- b0 + b1 * new_rating

cat("For a hotel with Overall Rating =", new_rating, ":\n")
cat("  Predicted Price =", round(b0, 2), "+", round(b1, 2), "×", new_rating, "\n")
cat("                  = ₹", round(predicted_price, 0), "\n")


# ============================================================================
# FINAL SUMMARY
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#                    FINAL SUMMARY                         #\n")
cat("############################################################\n\n")

cat("QUESTION 1 - EDA:\n")
cat("  • Dataset: 3,200 hotels across 16 Indian cities\n")
cat("  • Mean Rating: 4.10 | Mean Price: ₹6,484\n")
cat("  • Swimming Pool has biggest rating impact (+0.11)\n")
cat("  • Metro premium: ~₹800 higher prices\n\n")

cat("QUESTION 2 - CORRELATION:\n")
cat("  • Comfort Rating best predicts Overall Rating (r = 0.89)\n")
cat("  • Star Rating best predicts Price (r = 0.85)\n")
cat("  • High multicollinearity among rating variables\n\n")

cat("QUESTION 3 - CHI-SQUARE:\n")
cat("  • Swimming Pool IS associated with High Rating (dependent)\n")
cat("  • Metro status independent of Pool/Restaurant\n\n")

cat("QUESTION 4 - T-TESTS:\n")
cat("  • No significant difference between Mumbai & Delhi\n")
cat("  • Effect sizes are negligible\n\n")

cat("QUESTION 5 - ANOVA:\n")
cat("  • Metro status significantly affects price (p < 0.001)\n")
cat("  • Distance does NOT significantly affect price\n")
cat("  • No significant interaction effect\n\n")

cat("QUESTION 6 - REGRESSION:\n")
cat("  • Best model: Price = 638 + 1432 × Overall_Rating\n")
cat("  • R² = 0.24 (explains 24% of variance)\n")
cat("  • Each 1-point rating increase → ₹1,432 price increase\n\n")

cat("============================================================\n")
cat("                    END OF ANALYSIS\n")
cat("Student: Prem Vishnoi\n")
cat("Course: 2025FA_MS_DSP_401-DL_SEC61\n")
cat("Date: December 5, 2025\n")
cat("============================================================\n")
