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
library(readxl)
library(dplyr)
library(ggplot2)
library(corrplot)
library(car)
library(psych)

# ----------------------------------------------------------------------------
# LOAD THE DATA
# ----------------------------------------------------------------------------
# IMPORTANT: Update this path to your file location
file_path <- "/Users/pvishnoi/PycharmProjects/msds-northwestern-projects-2025/MSDS401/Final_Assignment/Hotel_Data_Final_Exam.xlsx"

df <- read_excel(file_path)

cat("\n========================================\n")
cat("DATA LOADED SUCCESSFULLY!\n")
cat("========================================\n")
cat("Total hotels:", nrow(df), "\n")
cat("Total variables:", ncol(df), "\n\n")

# Store original column names then clean them
original_names <- names(df)
names(df) <- gsub(" ", "_", names(df))
names(df) <- gsub("-", "_", names(df))

cat("Column names after cleaning:\n")
print(names(df))

# Convert Metro to numeric (TRUE=1, FALSE=0)
df$Metro <- as.integer(df$Metro)

# Verify key columns exist
cat("\n\nVerifying key columns:\n")
cat("  'City' exists:", "City" %in% names(df), "\n")
cat("  'Average_Room_Price' exists:", "Average_Room_Price" %in% names(df), "\n")
cat("  'Overall_Rating' exists:", "Overall_Rating" %in% names(df), "\n")

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

cat("Dataset Dimensions:\n")
cat("  Number of rows (hotels):", nrow(df), "\n")
cat("  Number of columns (variables):", ncol(df), "\n\n")

# Check for missing values
cat("Missing Values Check:\n")
missing_counts <- colSums(is.na(df))
if(sum(missing_counts) > 0) {
  print(missing_counts[missing_counts > 0])
} else {
  cat("  No missing values found!\n")
}

# ----------------------------------------------------------------------------
# 1.2 Summary Statistics for Continuous Variables
# ----------------------------------------------------------------------------
cat("\n--- 1.2 Summary Statistics for Continuous Variables ---\n\n")

# Rating variables
rating_vars <- c("Staff", "Facilities", "Cleanliness", "Value_for_Money",
                 "Location", "Free_Wi_Fi", "Comfort", "Overall_Rating")

# Other continuous variables
other_continuous <- c("Number_of_Ratings", "Distance_from_Center", "Average_Room_Price")

all_continuous <- c(rating_vars, other_continuous)
all_continuous <- all_continuous[all_continuous %in% names(df)]

# Get descriptive statistics
summary_stats <- describe(df[, all_continuous])
cat("Descriptive Statistics for Continuous Variables:\n")
print(round(summary_stats[, c("n", "mean", "sd", "min", "median", "max", "skew", "kurtosis")], 3))

cat("\n\nKEY OBSERVATIONS:\n")
cat("- Overall Rating: Mean =", round(mean(df$Overall_Rating), 2),
    ", SD =", round(sd(df$Overall_Rating), 2), "\n")
cat("- Average Room Price: Mean = Rs.", round(mean(df$Average_Room_Price), 0),
    ", SD = Rs.", round(sd(df$Average_Room_Price), 0), "\n")
cat("- Number of Ratings: Mean =", round(mean(df$Number_of_Ratings), 0),
    ", Median =", median(df$Number_of_Ratings), "(right-skewed)\n")

# ----------------------------------------------------------------------------
# 1.3 Distribution Visualizations
# ----------------------------------------------------------------------------
cat("\n--- 1.3 Creating Distribution Plots ---\n")

pdf("Q1_Distribution_Plots.pdf", width = 14, height = 10)
par(mfrow = c(3, 4), mar = c(4, 4, 3, 1))

for(var in rating_vars) {
  if(var %in% names(df)) {
    hist(df[[var]], breaks = 30, col = "steelblue", border = "white",
         main = paste(gsub("_", " ", var), "\nMean =", round(mean(df[[var]], na.rm=TRUE), 2)),
         xlab = "Rating (1-10)", ylab = "Frequency", cex.main = 0.9)
    abline(v = mean(df[[var]], na.rm=TRUE), col = "red", lwd = 2, lty = 2)
  }
}

hist(df$Average_Room_Price, breaks = 50, col = "forestgreen", border = "white",
     main = paste("Average Room Price\nMean = Rs.", round(mean(df$Average_Room_Price), 0)),
     xlab = "Price (INR)", ylab = "Frequency", cex.main = 0.9)
abline(v = mean(df$Average_Room_Price), col = "red", lwd = 2, lty = 2)

hist(df$Number_of_Ratings, breaks = 50, col = "orange", border = "white",
     main = paste("Number of Ratings\nMedian =", median(df$Number_of_Ratings)),
     xlab = "Count", ylab = "Frequency", cex.main = 0.9)

hist(df$Distance_from_Center, breaks = 40, col = "purple", border = "white",
     main = paste("Distance from Center\nMean =", round(mean(df$Distance_from_Center), 1), "km"),
     xlab = "Distance (km)", ylab = "Frequency", cex.main = 0.9)

dev.off()
cat("Distribution plots saved to: Q1_Distribution_Plots.pdf\n")

# ----------------------------------------------------------------------------
# 1.4 Hotel Features Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.4 Hotel Features/Amenities Analysis ---\n\n")

feature_cols <- c("X24_hour_front_desk", "X24_hour_security", "cctv_outside_property",
                  "cctv_in_common_areas", "room_service", "family_rooms",
                  "luggage_storage", "non_smoking_rooms", "flat_screen_tv",
                  "air_conditioning", "fan", "shower", "free_toiletries",
                  "towels", "toilet_paper", "daily_housekeeping",
                  "ironing_service", "laundry")

existing_features <- feature_cols[feature_cols %in% names(df)]

if(length(existing_features) > 0) {
  feature_summary <- data.frame(
    Feature = gsub("_", " ", existing_features),
    Hotels_With = sapply(existing_features, function(x) sum(df[[x]], na.rm=TRUE)),
    Percentage = sapply(existing_features, function(x) round(mean(df[[x]], na.rm=TRUE) * 100, 1)),
    Avg_Rating_With = sapply(existing_features, function(x)
      round(mean(df$Overall_Rating[df[[x]] == 1], na.rm=TRUE), 2)),
    Avg_Rating_Without = sapply(existing_features, function(x)
      round(mean(df$Overall_Rating[df[[x]] == 0], na.rm=TRUE), 2))
  )
  feature_summary$Rating_Impact <- feature_summary$Avg_Rating_With - feature_summary$Avg_Rating_Without
  rownames(feature_summary) <- NULL

  cat("Feature Analysis - Impact on Rating:\n")
  print(feature_summary[order(-feature_summary$Rating_Impact), ])
}

# ----------------------------------------------------------------------------
# 1.5 Metro vs Non-Metro Comparison
# ----------------------------------------------------------------------------
cat("\n--- 1.5 Metro vs Non-Metro Comparison ---\n\n")

metro_summary <- df %>%
  group_by(Metro) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(df)*100, 1),
    Avg_Rating = round(mean(Overall_Rating), 3),
    SD_Rating = round(sd(Overall_Rating), 3),
    Avg_Price = round(mean(Average_Room_Price), 0),
    SD_Price = round(sd(Average_Room_Price), 0),
    .groups = "drop"
  )
metro_summary$Type <- ifelse(metro_summary$Metro == 1, "Metro", "Non-Metro")

cat("Metro vs Non-Metro Hotels:\n")
print(metro_summary[, c("Type", "Count", "Pct", "Avg_Rating", "SD_Rating", "Avg_Price", "SD_Price")])

metro_price <- mean(df$Average_Room_Price[df$Metro == 1])
nonmetro_price <- mean(df$Average_Room_Price[df$Metro == 0])
cat("\nMetro Price Premium: Rs.", round(metro_price - nonmetro_price, 0), "\n")

pdf("Q1_Metro_Comparison.pdf", width = 10, height = 5)
par(mfrow = c(1, 2), mar = c(5, 4, 4, 2))
boxplot(Overall_Rating ~ Metro, data = df,
        names = c("Non-Metro", "Metro"), col = c("lightblue", "salmon"),
        main = "Overall Rating by Metro Status", ylab = "Rating")
boxplot(Average_Room_Price ~ Metro, data = df,
        names = c("Non-Metro", "Metro"), col = c("lightblue", "salmon"),
        main = "Room Price by Metro Status", ylab = "Price (INR)")
dev.off()
cat("Metro comparison plots saved to: Q1_Metro_Comparison.pdf\n")

# ----------------------------------------------------------------------------
# 1.6 City-wise Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.6 City-wise Analysis ---\n\n")

city_summary <- df %>%
  group_by(City) %>%
  summarise(
    Count = n(),
    Avg_Rating = round(mean(Overall_Rating), 2),
    Avg_Price = round(mean(Average_Room_Price), 0),
    .groups = "drop"
  ) %>%
  arrange(desc(Count))

cat("Hotels by City (sorted by count):\n")
print(as.data.frame(city_summary))

# ----------------------------------------------------------------------------
# 1.7 EDA Summary
# ----------------------------------------------------------------------------
cat("\n\n--- 1.7 EDA SUMMARY ---\n")
cat("============================================================\n")
cat("1. Dataset:", nrow(df), "hotels across", length(unique(df$City)), "cities\n")
cat("2. Overall Rating: Mean =", round(mean(df$Overall_Rating), 2), "\n")
cat("3. Average Room Price: Rs.", round(mean(df$Average_Room_Price), 0), "\n")
cat("4. Metro hotels:", sum(df$Metro == 1), "| Non-Metro:", sum(df$Metro == 0), "\n")
cat("5. Metro price premium: Rs.", round(metro_price - nonmetro_price, 0), "\n")
cat("============================================================\n")


# ============================================================================
# QUESTION 2: CORRELATION ANALYSIS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#            QUESTION 2: CORRELATION ANALYSIS              #\n")
cat("############################################################\n")

cat("\n--- 2.1 Correlation Matrix ---\n\n")

corr_vars <- c("Overall_Rating", "Staff", "Facilities", "Cleanliness",
               "Value_for_Money", "Location", "Free_Wi_Fi", "Comfort",
               "Average_Room_Price", "Number_of_Ratings", "Distance_from_Center")
corr_vars <- corr_vars[corr_vars %in% names(df)]

cor_matrix <- cor(df[, corr_vars], use = "complete.obs")
cat("Correlation Matrix:\n")
print(round(cor_matrix, 3))

pdf("Q2_Correlation_Heatmap.pdf", width = 12, height = 10)
corrplot(cor_matrix, method = "color", type = "upper", addCoef.col = "black",
         number.cex = 0.7, tl.col = "black", tl.srt = 45, tl.cex = 0.8,
         col = colorRampPalette(c("#D73027", "#FFFFBF", "#1A9850"))(100),
         title = "Correlation Matrix - Hotel Data", mar = c(0, 0, 2, 0))
dev.off()
cat("Correlation heatmap saved to: Q2_Correlation_Heatmap.pdf\n")

cat("\n--- 2.2 Correlations with Overall Rating ---\n\n")
other_vars <- corr_vars[corr_vars != "Overall_Rating"]
cor_with_overall <- data.frame(
  Variable = other_vars,
  Correlation = sapply(other_vars, function(x)
    round(cor(df$Overall_Rating, df[[x]], use = "complete.obs"), 4))
)
cor_with_overall <- cor_with_overall[order(-abs(cor_with_overall$Correlation)), ]
print(cor_with_overall)

cat("\n--- 2.3 Correlations with Average Room Price ---\n\n")
other_vars2 <- corr_vars[corr_vars != "Average_Room_Price"]
cor_with_price <- data.frame(
  Variable = other_vars2,
  Correlation = sapply(other_vars2, function(x)
    round(cor(df$Average_Room_Price, df[[x]], use = "complete.obs"), 4))
)
cor_with_price <- cor_with_price[order(-abs(cor_with_price$Correlation)), ]
print(cor_with_price)

cat("\n--- 2.4 CORRELATION SUMMARY ---\n")
cat("============================================================\n")
cat("Best predictors for Overall Rating: Facilities, Staff, Cleanliness\n")
cat("Best predictors for Price: Overall Rating, Comfort, Facilities\n")
cat("Value for Money negatively correlates with Price (makes sense!)\n")
cat("============================================================\n")


# ============================================================================
# QUESTION 3: CHI-SQUARE TESTS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#      QUESTION 3: CHI-SQUARE TESTS OF INDEPENDENCE        #\n")
cat("############################################################\n")

# Create binary high rating variable
df$Rating_High <- ifelse(df$Overall_Rating >= 7.5, 1, 0)

cat("\nSelected Binary Variables:\n")
cat("1. Metro (0=Non-Metro, 1=Metro)\n")
cat("2. room_service (0=No, 1=Yes)\n")
cat("3. air_conditioning (0=No, 1=Yes)\n")
cat("4. Rating_High (0=<7.5, 1=>=7.5)\n\n")

# Chi-square test function
do_chi_test <- function(var1_name, var2_name, label1, label2) {
  cat("\n========== TEST:", label1, "vs", label2, "==========\n\n")

  tbl <- table(df[[var1_name]], df[[var2_name]])
  cat("Contingency Table:\n")
  print(addmargins(tbl))

  chi_res <- chisq.test(tbl)
  cat("\nChi-Square =", round(chi_res$statistic, 4), "\n")
  cat("df =", chi_res$parameter, "\n")
  cat("p-value =", format(chi_res$p.value, scientific = TRUE, digits = 4), "\n")
  cat("Decision:", ifelse(chi_res$p.value < 0.05, "REJECT H0 - Variables are DEPENDENT",
                          "FAIL TO REJECT H0 - Variables are INDEPENDENT"), "\n")

  return(chi_res)
}

chi1 <- do_chi_test("Metro", "room_service", "Metro", "Room Service")
chi2 <- do_chi_test("Metro", "air_conditioning", "Metro", "Air Conditioning")
chi3 <- do_chi_test("room_service", "Rating_High", "Room Service", "High Rating")
chi4 <- do_chi_test("air_conditioning", "Rating_High", "Air Conditioning", "High Rating")

cat("\n\n========== CHI-SQUARE SUMMARY ==========\n")
chi_summary <- data.frame(
  Test = c("Metro vs Room Service", "Metro vs AC", "Room Service vs High Rating", "AC vs High Rating"),
  Chi_Sq = round(c(chi1$statistic, chi2$statistic, chi3$statistic, chi4$statistic), 2),
  p_value = format(c(chi1$p.value, chi2$p.value, chi3$p.value, chi4$p.value), scientific=TRUE, digits=3),
  Result = c(ifelse(chi1$p.value < 0.05, "Dependent", "Independent"),
             ifelse(chi2$p.value < 0.05, "Dependent", "Independent"),
             ifelse(chi3$p.value < 0.05, "Dependent", "Independent"),
             ifelse(chi4$p.value < 0.05, "Dependent", "Independent"))
)
print(chi_summary)


# ============================================================================
# QUESTION 4: TWO-CITY T-TESTS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#    QUESTION 4: TWO-SAMPLE T-TESTS (TWO CITIES)           #\n")
cat("############################################################\n")

cat("\n--- 4.1 Cities with 100+ Hotels ---\n\n")

city_counts <- df %>%
  group_by(City) %>%
  summarise(Count = n(), .groups = "drop") %>%
  filter(Count >= 100) %>%
  arrange(desc(Count))

cat("Cities with 100+ hotels:\n")
print(as.data.frame(city_counts))

# Get the two largest cities
city1 <- as.character(city_counts$City[1])  # Bangalore
city2 <- as.character(city_counts$City[2])  # Delhi

cat("\nSelected cities:", city1, "and", city2, "\n")

# Filter data for each city
df_city1 <- df[df$City == city1, ]
df_city2 <- df[df$City == city2, ]

cat("\nCity 1:", city1, "- n =", nrow(df_city1), "hotels\n")
cat("City 2:", city2, "- n =", nrow(df_city2), "hotels\n")

# Check if we have enough data
if(nrow(df_city1) < 2 | nrow(df_city2) < 2) {
  cat("\nERROR: Not enough data for t-test!\n")
} else {

  cat("\n--- 4.2 Descriptive Statistics ---\n\n")
  cat(city1, ":\n")
  cat("  Price: Mean = Rs.", round(mean(df_city1$Average_Room_Price), 0),
      ", SD = Rs.", round(sd(df_city1$Average_Room_Price), 0), "\n")
  cat("  Rating: Mean =", round(mean(df_city1$Overall_Rating), 3),
      ", SD =", round(sd(df_city1$Overall_Rating), 3), "\n")

  cat("\n", city2, ":\n", sep="")
  cat("  Price: Mean = Rs.", round(mean(df_city2$Average_Room_Price), 0),
      ", SD = Rs.", round(sd(df_city2$Average_Room_Price), 0), "\n")
  cat("  Rating: Mean =", round(mean(df_city2$Overall_Rating), 3),
      ", SD =", round(sd(df_city2$Overall_Rating), 3), "\n")

  # T-test for Price
  cat("\n--- 4.3 T-Test: Average Room Price ---\n\n")

  price1 <- df_city1$Average_Room_Price
  price2 <- df_city2$Average_Room_Price

  t_price <- t.test(price1, price2, var.equal = FALSE)

  cat("H0: Mean prices are equal\n")
  cat("H1: Mean prices are different\n\n")
  cat("t-statistic =", round(t_price$statistic, 4), "\n")
  cat("df =", round(t_price$parameter, 2), "\n")
  cat("p-value =", format(t_price$p.value, scientific = TRUE, digits = 4), "\n")
  cat("95% CI: (", round(t_price$conf.int[1], 2), ", ", round(t_price$conf.int[2], 2), ")\n", sep="")
  cat("\nDecision:", ifelse(t_price$p.value < 0.05,
                            "REJECT H0 - Significant price difference",
                            "FAIL TO REJECT H0 - No significant price difference"), "\n")

  # T-test for Rating
  cat("\n--- 4.4 T-Test: Overall Rating ---\n\n")

  rating1 <- df_city1$Overall_Rating
  rating2 <- df_city2$Overall_Rating

  t_rating <- t.test(rating1, rating2, var.equal = FALSE)

  cat("H0: Mean ratings are equal\n")
  cat("H1: Mean ratings are different\n\n")
  cat("t-statistic =", round(t_rating$statistic, 4), "\n")
  cat("df =", round(t_rating$parameter, 2), "\n")
  cat("p-value =", format(t_rating$p.value, scientific = TRUE, digits = 4), "\n")
  cat("95% CI: (", round(t_rating$conf.int[1], 4), ", ", round(t_rating$conf.int[2], 4), ")\n", sep="")
  cat("\nDecision:", ifelse(t_rating$p.value < 0.05,
                            "REJECT H0 - Significant rating difference",
                            "FAIL TO REJECT H0 - No significant rating difference"), "\n")

  # Effect sizes
  cat("\n--- 4.5 Effect Size (Cohen's d) ---\n\n")
  n1 <- length(price1)
  n2 <- length(price2)

  pooled_sd_price <- sqrt(((n1-1)*var(price1) + (n2-1)*var(price2)) / (n1+n2-2))
  d_price <- (mean(price1) - mean(price2)) / pooled_sd_price

  pooled_sd_rating <- sqrt(((n1-1)*var(rating1) + (n2-1)*var(rating2)) / (n1+n2-2))
  d_rating <- (mean(rating1) - mean(rating2)) / pooled_sd_rating

  interpret_d <- function(d) {
    if(abs(d) < 0.2) return("Negligible")
    if(abs(d) < 0.5) return("Small")
    if(abs(d) < 0.8) return("Medium")
    return("Large")
  }

  cat("Cohen's d (Price):", round(d_price, 4), "-", interpret_d(d_price), "effect\n")
  cat("Cohen's d (Rating):", round(d_rating, 4), "-", interpret_d(d_rating), "effect\n")

  # Visualization
  pdf("Q4_City_Comparison.pdf", width = 10, height = 5)
  par(mfrow = c(1, 2), mar = c(5, 4, 4, 2))
  boxplot(price1, price2, names = c(city1, city2),
          col = c("lightblue", "salmon"),
          main = paste("Room Price\np =", format(t_price$p.value, digits = 3)),
          ylab = "Price (INR)")
  boxplot(rating1, rating2, names = c(city1, city2),
          col = c("lightblue", "salmon"),
          main = paste("Overall Rating\np =", format(t_rating$p.value, digits = 3)),
          ylab = "Rating")
  dev.off()
  cat("\nCity comparison plots saved to: Q4_City_Comparison.pdf\n")

  cat("\n--- 4.6 QUESTION 4 SUMMARY ---\n")
  cat("============================================================\n")
  cat("Compared:", city1, "(n=", nrow(df_city1), ") vs", city2, "(n=", nrow(df_city2), ")\n")
  cat("Price:", ifelse(t_price$p.value < 0.05, "SIGNIFICANT", "Not significant"), "difference\n")
  cat("Rating:", ifelse(t_rating$p.value < 0.05, "SIGNIFICANT", "Not significant"), "difference\n")
  cat("============================================================\n")
}


# ============================================================================
# QUESTION 5: ANOVA
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#                   QUESTION 5: ANOVA                      #\n")
cat("############################################################\n")

cat("\nResearch Question: Does Average Room Price depend on Metro status\n")
cat("and/or Distance from City Center?\n\n")

# Create factor variables
df$Metro_Factor <- factor(df$Metro, levels = c(0, 1), labels = c("Non-Metro", "Metro"))
df$Distance_Factor <- factor(df$Categorized_Dist_from_Centre)

cat("--- 5.1 Group Statistics ---\n\n")

# By Metro
metro_stats <- df %>%
  group_by(Metro_Factor) %>%
  summarise(N = n(), Mean_Price = round(mean(Average_Room_Price), 0),
            SD = round(sd(Average_Room_Price), 0), .groups = "drop")
cat("By Metro Status:\n")
print(as.data.frame(metro_stats))

# By Distance
cat("\nBy Distance:\n")
dist_stats <- df %>%
  group_by(Distance_Factor) %>%
  summarise(N = n(), Mean_Price = round(mean(Average_Room_Price), 0),
            SD = round(sd(Average_Room_Price), 0), .groups = "drop")
print(as.data.frame(dist_stats))

cat("\n--- 5.2 Two-Way ANOVA ---\n\n")

anova_model <- aov(Average_Room_Price ~ Metro_Factor * Distance_Factor, data = df)
anova_results <- summary(anova_model)
cat("ANOVA Table:\n")
print(anova_results)

anova_table <- anova_results[[1]]
p_metro <- anova_table["Metro_Factor", "Pr(>F)"]
p_distance <- anova_table["Distance_Factor", "Pr(>F)"]
p_interaction <- anova_table["Metro_Factor:Distance_Factor", "Pr(>F)"]

cat("\n--- 5.3 ANOVA Interpretation ---\n\n")
cat("1. Metro Effect: F =", round(anova_table["Metro_Factor", "F value"], 2),
    ", p =", format(p_metro, digits = 4), "\n")
cat("   ", ifelse(p_metro < 0.05, "SIGNIFICANT", "Not significant"), "\n\n")

cat("2. Distance Effect: F =", round(anova_table["Distance_Factor", "F value"], 2),
    ", p =", format(p_distance, digits = 4), "\n")
cat("   ", ifelse(p_distance < 0.05, "SIGNIFICANT", "Not significant"), "\n\n")

cat("3. Interaction: F =", round(anova_table["Metro_Factor:Distance_Factor", "F value"], 2),
    ", p =", format(p_interaction, digits = 4), "\n")
cat("   ", ifelse(p_interaction < 0.05, "SIGNIFICANT interaction", "NO significant interaction"), "\n")

# Tukey test
cat("\n--- 5.4 Tukey's HSD for Distance ---\n\n")
anova_dist <- aov(Average_Room_Price ~ Distance_Factor, data = df)
tukey_result <- TukeyHSD(anova_dist)
print(tukey_result)

# Visualization
pdf("Q5_ANOVA_Plots.pdf", width = 12, height = 5)
par(mfrow = c(1, 2), mar = c(5, 4, 4, 2))

metro_means <- tapply(df$Average_Room_Price, df$Metro_Factor, mean)
barplot(metro_means, col = c("skyblue", "coral"),
        main = "Mean Price by Metro Status", ylab = "Mean Price (INR)")

interaction.plot(df$Distance_Factor, df$Metro_Factor, df$Average_Room_Price,
                 col = c("blue", "red"), lwd = 2, type = "b",
                 main = "Interaction Plot", xlab = "Distance", ylab = "Mean Price",
                 trace.label = "Metro", cex.axis = 0.7)
dev.off()
cat("\nANOVA plots saved to: Q5_ANOVA_Plots.pdf\n")

cat("\n--- 5.5 QUESTION 5 SUMMARY ---\n")
cat("============================================================\n")
cat("Metro effect:", ifelse(p_metro < 0.05, "SIGNIFICANT", "Not significant"), "\n")
cat("Distance effect:", ifelse(p_distance < 0.05, "SIGNIFICANT", "Not significant"), "\n")
cat("Interaction:", ifelse(p_interaction < 0.05, "SIGNIFICANT", "Not significant"), "\n")
cat("============================================================\n")


# ============================================================================
# QUESTION 6: REGRESSION MODELING
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#            QUESTION 6: REGRESSION MODELING               #\n")
cat("############################################################\n")

cat("\nObjective: Predict Average Room Price using Overall Rating, Location,\n")
cat("           Value for Money, and Comfort ratings.\n\n")

# Full model
cat("--- 6.1 Full Model ---\n\n")
model_full <- lm(Average_Room_Price ~ Overall_Rating + Location +
                   Value_for_Money + Comfort, data = df)
cat("Full Model Summary:\n")
print(summary(model_full))

# VIF
cat("\n--- 6.2 VIF (Multicollinearity Check) ---\n\n")
vif_vals <- vif(model_full)
print(round(vif_vals, 2))
cat("\nVIF > 5 indicates multicollinearity concern\n")

# Model comparison
cat("\n--- 6.3 Model Comparison ---\n\n")
model1 <- lm(Average_Room_Price ~ Overall_Rating + Location + Value_for_Money + Comfort, data = df)
model2 <- lm(Average_Room_Price ~ Overall_Rating + Value_for_Money + Comfort, data = df)
model3 <- lm(Average_Room_Price ~ Overall_Rating + Comfort, data = df)
model4 <- lm(Average_Room_Price ~ Overall_Rating, data = df)

comparison <- data.frame(
  Model = c("Full (4 vars)", "No Location", "Overall + Comfort", "Overall Only"),
  R_Sq = round(c(summary(model1)$r.squared, summary(model2)$r.squared,
                 summary(model3)$r.squared, summary(model4)$r.squared), 4),
  Adj_R_Sq = round(c(summary(model1)$adj.r.squared, summary(model2)$adj.r.squared,
                     summary(model3)$adj.r.squared, summary(model4)$adj.r.squared), 4),
  AIC = round(c(AIC(model1), AIC(model2), AIC(model3), AIC(model4)), 1)
)
print(comparison)

# Stepwise selection
cat("\n--- 6.4 Stepwise Selection ---\n\n")
step_model <- step(model_full, direction = "backward", trace = 1)
cat("\nFinal Model from Stepwise:\n")
print(summary(step_model))

# Best model
best_model <- step_model
coefs <- coef(best_model)

cat("\n--- 6.5 Regression Equation ---\n")
cat("============================================================\n")
cat("Average_Room_Price =", round(coefs[1], 2))
for(i in 2:length(coefs)) {
  sign <- ifelse(coefs[i] >= 0, "+", "-")
  cat("", sign, round(abs(coefs[i]), 2), "*", names(coefs)[i])
}
cat("\n============================================================\n")

cat("\nModel R-squared:", round(summary(best_model)$r.squared, 4), "\n")
cat("Adjusted R-squared:", round(summary(best_model)$adj.r.squared, 4), "\n")

# Residual diagnostics
cat("\n--- 6.6 Residual Analysis ---\n\n")
residuals_model <- resid(best_model)
cat("Residual Mean:", round(mean(residuals_model), 6), "\n")
cat("Residual SD:", round(sd(residuals_model), 2), "\n")

pdf("Q6_Regression_Diagnostics.pdf", width = 10, height = 10)
par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))
plot(fitted(best_model), residuals_model, pch = 19, col = rgb(0,0,1,0.2),
     main = "Residuals vs Fitted", xlab = "Fitted", ylab = "Residuals")
abline(h = 0, col = "red", lwd = 2, lty = 2)
qqnorm(residuals_model, pch = 19, col = rgb(0,0,1,0.3))
qqline(residuals_model, col = "red", lwd = 2)
hist(residuals_model, breaks = 50, col = "lightblue", main = "Residuals Distribution")
plot(df$Average_Room_Price, fitted(best_model), pch = 19, col = rgb(0,0,1,0.2),
     main = "Actual vs Predicted", xlab = "Actual", ylab = "Predicted")
abline(0, 1, col = "red", lwd = 2)
dev.off()
cat("Diagnostic plots saved to: Q6_Regression_Diagnostics.pdf\n")

cat("\n--- 6.7 QUESTION 6 SUMMARY ---\n")
cat("============================================================\n")
cat("Best Model R-squared:", round(summary(best_model)$r.squared, 4), "\n")
cat("Key findings:\n")
cat("- Overall Rating and Comfort have POSITIVE effects on price\n")
cat("- Value for Money has NEGATIVE effect (higher value = lower price)\n")
cat("- Rating variables have high multicollinearity\n")
cat("============================================================\n")


# ============================================================================
# FINAL SUMMARY
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#                    FINAL SUMMARY                         #\n")
cat("############################################################\n\n")

cat("Q1 - EDA: Dataset has", nrow(df), "hotels,", length(unique(df$City)), "cities\n")
cat("Q2 - Correlation: Rating variables highly correlated (r > 0.75)\n")
cat("Q3 - Chi-Square: Amenities associated with higher ratings\n")
cat("Q4 - T-Tests:", city1, "vs", city2, "comparison completed\n")
cat("Q5 - ANOVA: Metro and Distance effects on price tested\n")
cat("Q6 - Regression: Best model R² =", round(summary(best_model)$r.squared, 4), "\n\n")

cat("============================================================\n")
cat("                    END OF ANALYSIS\n")
cat("Student: Prem Vishnoi\n")
cat("Course: 2025FA_MS_DSP_401-DL_SEC61\n")
cat("Date: December 5, 2025\n")
cat("============================================================\n")
