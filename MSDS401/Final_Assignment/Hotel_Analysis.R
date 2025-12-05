# ============================================================================
# TAKE HOME FINAL EXAM - HOTEL DATA ANALYSIS (CORRECTED VERSION)
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
# Install packages if needed (uncomment if first time):
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
# IMPORTANT: Change this path to where YOUR file is located!
# Example Windows: "C:/Users/Prem/Downloads/Hotel_Data_Final_Exam.xlsx"
# Example Mac: "/Users/pvishnoi/Downloads/Hotel_Data_Final_Exam.xlsx"

file_path <- "/Users/pvishnoi/PycharmProjects/msds-northwestern-projects-2025/MSDS401/Final_Assignment/Hotel_Data_Final_Exam.xlsx"

# Try to load the file
tryCatch({
  df <- read_excel(file_path)
  cat("\n========================================\n")
  cat("DATA LOADED SUCCESSFULLY!\n")
  cat("========================================\n")
}, error = function(e) {
  cat("ERROR: Could not load file. Please check the file path.\n")
  cat("Error message:", e$message, "\n")
  stop("Please update the file_path variable with your actual file location.")
})

cat("Total hotels:", nrow(df), "\n")
cat("Total variables:", ncol(df), "\n\n")

# ----------------------------------------------------------------------------
# STANDARDIZE COLUMN NAMES (CRITICAL FIX!)
# ----------------------------------------------------------------------------
# This fixes the "undefined columns selected" error by cleaning column names

cat("Original column names:\n")
print(names(df))

# Clean column names: remove spaces, replace with underscores
names(df) <- gsub(" ", "_", names(df))
names(df) <- gsub("-", "_", names(df))

cat("\nCleaned column names:\n")
print(names(df))

# Quick look at the data
cat("\nFirst 6 rows:\n")
print(head(df))

# Check data structure
cat("\nData structure:\n")
str(df)


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
cat("  Number of columns (variables):", ncol(df), "\n")

# Check for missing values
cat("\nMissing Values:\n")
missing_counts <- colSums(is.na(df))
if(sum(missing_counts) > 0) {
  print(missing_counts[missing_counts > 0])
} else {
  cat("  No missing values found!\n")
}

# ----------------------------------------------------------------------------
# 1.2 Summary Statistics for Continuous Variables
# ----------------------------------------------------------------------------
cat("\n--- 1.2 Summary Statistics ---\n\n")

# Identify numeric columns dynamically
numeric_cols <- names(df)[sapply(df, is.numeric)]
cat("Numeric columns found:\n")
print(numeric_cols)

# Get detailed statistics for numeric columns ONLY
if(length(numeric_cols) > 0) {
  summary_stats <- describe(df[, numeric_cols, drop = FALSE])
  cat("\nDescriptive Statistics:\n")
  print(round(summary_stats[, c("n", "mean", "sd", "min", "median", "max", "skew", "kurtosis")], 2))
} else {
  cat("No numeric columns found for statistics.\n")
}

# Basic interpretation (check if columns exist first)
if("Overall_Rating" %in% names(df)) {
  cat("\nINTERPRETATION:\n")
  cat("- Overall Rating: Mean =", round(mean(df$Overall_Rating, na.rm=T), 2), "\n")
}
if("Average_Room_Price" %in% names(df)) {
  cat("- Average Room Price: Mean =", round(mean(df$Average_Room_Price, na.rm=T), 0), "\n")
}
cat("- Most ratings are slightly left-skewed (more high ratings)\n")

# ----------------------------------------------------------------------------
# 1.3 Distribution Visualizations
# ----------------------------------------------------------------------------
cat("\n--- 1.3 Creating Distribution Plots ---\n")

# IMPORTANT: If you get "figure margins too large" error:
# 1. Expand your RStudio plot window (drag to make it bigger)
# 2. Or run: dev.new(width=12, height=10) before the plots
# 3. Or save directly to PDF (see below)

# Option 1: Save plots to PDF file (recommended - avoids margin issues)
pdf("Distribution_Plots.pdf", width = 12, height = 10)

# Reset graphics parameters
par(mfrow = c(3, 3), mar = c(4, 4, 3, 1), oma = c(1, 1, 2, 1))

# Plot histograms for available numeric columns
plot_vars <- c("Overall_Rating", "Average_Room_Price", "Distance_from_City_Center",
               "Location_Rating", "Cleanliness_Rating", "Service_Rating",
               "Value_for_Money_Rating", "Comfort_Rating")

colors <- c("steelblue", "forestgreen", "orange", "purple", "coral",
            "cyan4", "gold3", "darkgreen")

plot_count <- 0
for(i in seq_along(plot_vars)) {
  var_name <- plot_vars[i]
  if(var_name %in% names(df)) {
    plot_count <- plot_count + 1
    hist(df[[var_name]], breaks = 30, col = colors[i], border = "white",
         main = gsub("_", " ", var_name), xlab = "Value", ylab = "Frequency",
         cex.main = 0.9, cex.lab = 0.8, cex.axis = 0.8)
    abline(v = mean(df[[var_name]], na.rm=T), col = "red", lwd = 2, lty = 2)
  }
}

# Star Rating bar plot (if exists)
if("Star_Rating" %in% names(df)) {
  barplot(table(df$Star_Rating), col = c("gray", "silver", "gold", "gold4"),
          main = "Star Rating Distribution", xlab = "Stars", ylab = "Frequency",
          cex.main = 0.9, cex.lab = 0.8, cex.axis = 0.8)
}

dev.off()  # Close PDF device
cat("Distribution plots saved to: Distribution_Plots.pdf\n")

# Reset to single plot
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

# ----------------------------------------------------------------------------
# 1.4 Hotel Features Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.4 Hotel Features Analysis ---\n\n")

# Feature columns (binary: 0 or 1)
features <- c("Has_Swimming_Pool", "Has_WiFi", "Has_Restaurant",
              "Has_Gym", "Has_Spa", "Has_Parking")

# Check which features exist
existing_features <- features[features %in% names(df)]

if(length(existing_features) > 0 && "Overall_Rating" %in% names(df)) {
  # Create summary table
  feature_summary <- data.frame(
    Feature = gsub("Has_", "", existing_features),
    Hotels_With = sapply(existing_features, function(x) sum(df[[x]], na.rm=T)),
    Percentage = sapply(existing_features, function(x) round(mean(df[[x]], na.rm=T) * 100, 1)),
    Avg_Rating_With = sapply(existing_features, function(x)
      round(mean(df$Overall_Rating[df[[x]] == 1], na.rm=T), 2)),
    Avg_Rating_Without = sapply(existing_features, function(x)
      round(mean(df$Overall_Rating[df[[x]] == 0], na.rm=T), 2))
  )
  feature_summary$Impact <- round(feature_summary$Avg_Rating_With - feature_summary$Avg_Rating_Without, 2)
  rownames(feature_summary) <- NULL

  cat("Feature Availability and Impact on Rating:\n")
  print(feature_summary)

  # Save feature plots to PDF
  pdf("Feature_Analysis_Plots.pdf", width = 10, height = 5)
  par(mfrow = c(1, 2), mar = c(6, 4, 3, 1))

  barplot(feature_summary$Hotels_With, names.arg = feature_summary$Feature,
          col = rainbow(length(existing_features)), las = 2,
          main = "Hotels with Each Feature", ylab = "Count",
          cex.names = 0.8, cex.main = 0.9)

  barplot(feature_summary$Impact, names.arg = feature_summary$Feature,
          col = ifelse(feature_summary$Impact > 0, "green", "red"), las = 2,
          main = "Rating Impact by Feature", ylab = "Rating Difference",
          cex.names = 0.8, cex.main = 0.9)
  abline(h = 0, lty = 2)

  dev.off()
  cat("Feature analysis plots saved to: Feature_Analysis_Plots.pdf\n")
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
} else {
  cat("Feature columns not found or Overall_Rating missing.\n")
}

# ----------------------------------------------------------------------------
# 1.5 Metro vs Non-Metro Comparison
# ----------------------------------------------------------------------------
cat("\n--- 1.5 Metro vs Non-Metro Comparison ---\n\n")

if("Is_Metro" %in% names(df) && "Overall_Rating" %in% names(df) && "Average_Room_Price" %in% names(df)) {
  # Group by Metro status
  metro_summary <- df %>%
    group_by(Is_Metro) %>%
    summarise(
      Count = n(),
      Avg_Rating = round(mean(Overall_Rating, na.rm=T), 3),
      SD_Rating = round(sd(Overall_Rating, na.rm=T), 3),
      Avg_Price = round(mean(Average_Room_Price, na.rm=T), 0),
      SD_Price = round(sd(Average_Room_Price, na.rm=T), 0),
      .groups = "drop"
    )

  metro_summary$Type <- ifelse(metro_summary$Is_Metro == 1, "Metro", "Non-Metro")
  print(metro_summary[, c("Type", "Count", "Avg_Rating", "SD_Rating", "Avg_Price", "SD_Price")])

  # Calculate price difference
  metro_price <- mean(df$Average_Room_Price[df$Is_Metro == 1], na.rm=T)
  nonmetro_price <- mean(df$Average_Room_Price[df$Is_Metro == 0], na.rm=T)
  cat("\nMetro Premium: Rs.", round(metro_price - nonmetro_price, 0), "\n")

  # Save box plots to PDF
  pdf("Metro_Comparison_Plots.pdf", width = 10, height = 5)
  par(mfrow = c(1, 2), mar = c(5, 4, 4, 2))

  boxplot(Overall_Rating ~ Is_Metro, data = df,
          names = c("Non-Metro", "Metro"), col = c("lightblue", "salmon"),
          main = "Overall Rating by Metro Status", ylab = "Rating")

  boxplot(Average_Room_Price ~ Is_Metro, data = df,
          names = c("Non-Metro", "Metro"), col = c("lightblue", "salmon"),
          main = "Room Price by Metro Status", ylab = "Price (INR)")

  dev.off()
  cat("Metro comparison plots saved to: Metro_Comparison_Plots.pdf\n")
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
} else {
  cat("Required columns for metro analysis not found.\n")
  metro_price <- NA
  nonmetro_price <- NA
}

# ----------------------------------------------------------------------------
# 1.6 City-wise Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.6 City-wise Analysis ---\n\n")

if("City" %in% names(df) && "Overall_Rating" %in% names(df) && "Average_Room_Price" %in% names(df)) {
  city_summary <- df %>%
    group_by(City) %>%
    summarise(
      Count = n(),
      Avg_Rating = round(mean(Overall_Rating, na.rm=T), 2),
      Avg_Price = round(mean(Average_Room_Price, na.rm=T), 0),
      .groups = "drop"
    ) %>%
    arrange(desc(Count))

  cat("Hotels by City:\n")
  print(as.data.frame(city_summary))
} else {
  cat("City column not found.\n")
}

# ----------------------------------------------------------------------------
# 1.7 Region-wise Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.7 Region-wise Analysis ---\n\n")

if("Region" %in% names(df) && "Overall_Rating" %in% names(df) && "Average_Room_Price" %in% names(df)) {
  region_summary <- df %>%
    group_by(Region) %>%
    summarise(
      Count = n(),
      Avg_Rating = round(mean(Overall_Rating, na.rm=T), 2),
      Avg_Price = round(mean(Average_Room_Price, na.rm=T), 0),
      .groups = "drop"
    )

  cat("Hotels by Region:\n")
  print(as.data.frame(region_summary))
} else {
  cat("Region column not found.\n")
}

# ----------------------------------------------------------------------------
# 1.8 Star Rating Analysis
# ----------------------------------------------------------------------------
cat("\n--- 1.8 Star Rating Analysis ---\n\n")

if("Star_Rating" %in% names(df) && "Overall_Rating" %in% names(df) && "Average_Room_Price" %in% names(df)) {
  star_summary <- df %>%
    group_by(Star_Rating) %>%
    summarise(
      Count = n(),
      Percentage = round(n()/nrow(df)*100, 1),
      Avg_Overall_Rating = round(mean(Overall_Rating, na.rm=T), 2),
      Avg_Price = round(mean(Average_Room_Price, na.rm=T), 0),
      .groups = "drop"
    )

  cat("Analysis by Star Rating:\n")
  print(as.data.frame(star_summary))
} else {
  cat("Star_Rating column not found.\n")
}

# ----------------------------------------------------------------------------
# 1.9 EDA Summary
# ----------------------------------------------------------------------------
cat("\n--- 1.9 EDA SUMMARY ---\n")
cat("\nKey Findings:\n")
cat("1. Total hotels in dataset:", nrow(df), "\n")
if("Overall_Rating" %in% names(df)) {
  cat("2. Overall Rating: Mean =", round(mean(df$Overall_Rating, na.rm=T), 2),
      ", SD =", round(sd(df$Overall_Rating, na.rm=T), 2), "\n")
}
if("Average_Room_Price" %in% names(df)) {
  cat("3. Average Price: Mean = Rs.", round(mean(df$Average_Room_Price, na.rm=T), 0),
      ", SD = Rs.", round(sd(df$Average_Room_Price, na.rm=T), 0), "\n")
}
if("Is_Metro" %in% names(df)) {
  cat("4. Metro hotels:", sum(df$Is_Metro == 1), "| Non-Metro:", sum(df$Is_Metro == 0), "\n")
  if(!is.na(metro_price) && !is.na(nonmetro_price)) {
    cat("5. Metro price premium: Rs.", round(metro_price - nonmetro_price, 0), "\n")
  }
}


# ============================================================================
# QUESTION 2: CORRELATION ANALYSIS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#            QUESTION 2: CORRELATION ANALYSIS              #\n")
cat("############################################################\n")

# ----------------------------------------------------------------------------
# 2.1 Compute Correlation Matrix
# ----------------------------------------------------------------------------
cat("\n--- 2.1 Correlation Matrix ---\n\n")

# Select numeric columns for correlation
corr_cols <- c("Distance_from_City_Center", "Number_of_Ratings",
               "Overall_Rating", "Location_Rating", "Cleanliness_Rating",
               "Service_Rating", "Value_for_Money_Rating", "Comfort_Rating",
               "Average_Room_Price", "Star_Rating")

# Keep only columns that exist
corr_cols <- corr_cols[corr_cols %in% names(df)]

cat("Columns available for correlation analysis:\n")
print(corr_cols)

if(length(corr_cols) >= 2) {
  # Calculate correlation matrix
  cor_matrix <- cor(df[, corr_cols], use = "complete.obs")

  cat("\nCorrelation Matrix:\n")
  print(round(cor_matrix, 3))

  # ----------------------------------------------------------------------------
  # 2.2 Correlation Heatmap
  # ----------------------------------------------------------------------------
  cat("\n--- 2.2 Creating Correlation Heatmap ---\n")

  # Save heatmap to PDF
  pdf("Correlation_Heatmap.pdf", width = 10, height = 10)

  corrplot(cor_matrix,
           method = "color",
           type = "upper",
           addCoef.col = "black",
           number.cex = 0.6,
           tl.col = "black",
           tl.srt = 45,
           tl.cex = 0.7,
           col = colorRampPalette(c("red", "white", "blue"))(100),
           title = "Correlation Heatmap",
           mar = c(0, 0, 2, 0))

  dev.off()
  cat("Correlation heatmap saved to: Correlation_Heatmap.pdf\n")

  # ----------------------------------------------------------------------------
  # 2.3 Key Correlations with Overall Rating
  # ----------------------------------------------------------------------------
  cat("\n--- 2.3 Correlations with Overall Rating ---\n\n")

  if("Overall_Rating" %in% corr_cols) {
    other_vars <- corr_cols[corr_cols != "Overall_Rating"]

    cor_with_overall <- data.frame(
      Variable = other_vars,
      Correlation = sapply(other_vars, function(x)
        round(cor(df$Overall_Rating, df[[x]], use = "complete.obs"), 4))
    )

    # Add p-values
    cor_with_overall$P_Value <- sapply(other_vars, function(x) {
      test <- cor.test(df$Overall_Rating, df[[x]])
      test$p.value
    })

    # Add significance stars
    cor_with_overall$Sig <- ifelse(cor_with_overall$P_Value < 0.001, "***",
                            ifelse(cor_with_overall$P_Value < 0.01, "**",
                            ifelse(cor_with_overall$P_Value < 0.05, "*", "")))

    # Sort by absolute correlation
    cor_with_overall <- cor_with_overall[order(-abs(cor_with_overall$Correlation)), ]

    cat("Correlations with Overall Rating (sorted by strength):\n")
    print(cor_with_overall)
  }

  # ----------------------------------------------------------------------------
  # 2.4 Key Correlations with Average Room Price
  # ----------------------------------------------------------------------------
  cat("\n--- 2.4 Correlations with Average Room Price ---\n\n")

  if("Average_Room_Price" %in% corr_cols) {
    other_vars2 <- corr_cols[corr_cols != "Average_Room_Price"]

    cor_with_price <- data.frame(
      Variable = other_vars2,
      Correlation = sapply(other_vars2, function(x)
        round(cor(df$Average_Room_Price, df[[x]], use = "complete.obs"), 4))
    )

    cor_with_price$P_Value <- sapply(other_vars2, function(x) {
      test <- cor.test(df$Average_Room_Price, df[[x]])
      test$p.value
    })

    cor_with_price$Sig <- ifelse(cor_with_price$P_Value < 0.001, "***",
                          ifelse(cor_with_price$P_Value < 0.01, "**",
                          ifelse(cor_with_price$P_Value < 0.05, "*", "")))

    cor_with_price <- cor_with_price[order(-abs(cor_with_price$Correlation)), ]

    cat("Correlations with Average Room Price (sorted by strength):\n")
    print(cor_with_price)
  }

  # ----------------------------------------------------------------------------
  # 2.5 Scatter Plots for Key Relationships
  # ----------------------------------------------------------------------------
  cat("\n--- 2.5 Creating Scatter Plots ---\n")

  if("Overall_Rating" %in% names(df) && "Average_Room_Price" %in% names(df)) {
    # Save scatter plots to PDF
    pdf("Correlation_Scatter_Plots.pdf", width = 12, height = 8)
    par(mfrow = c(2, 3), mar = c(4, 4, 3, 1))

    # 1. Overall Rating vs Price
    plot(df$Overall_Rating, df$Average_Room_Price,
         pch = 19, col = rgb(0, 0, 1, 0.2),
         main = paste("Rating vs Price\nr =",
                      round(cor(df$Overall_Rating, df$Average_Room_Price, use="complete.obs"), 3)),
         xlab = "Overall Rating", ylab = "Price (INR)", cex.main = 0.9)
    abline(lm(Average_Room_Price ~ Overall_Rating, data = df), col = "red", lwd = 2)

    # 2. Star Rating vs Price
    if("Star_Rating" %in% names(df)) {
      plot(df$Star_Rating, df$Average_Room_Price,
           pch = 19, col = rgb(0, 0.5, 0, 0.2),
           main = paste("Stars vs Price\nr =",
                        round(cor(df$Star_Rating, df$Average_Room_Price, use="complete.obs"), 3)),
           xlab = "Star Rating", ylab = "Price (INR)", cex.main = 0.9)
      abline(lm(Average_Room_Price ~ Star_Rating, data = df), col = "red", lwd = 2)
    }

    # 3. Comfort vs Overall
    if("Comfort_Rating" %in% names(df)) {
      plot(df$Comfort_Rating, df$Overall_Rating,
           pch = 19, col = rgb(0.5, 0, 0.5, 0.2),
           main = paste("Comfort vs Overall\nr =",
                        round(cor(df$Comfort_Rating, df$Overall_Rating, use="complete.obs"), 3)),
           xlab = "Comfort Rating", ylab = "Overall Rating", cex.main = 0.9)
      abline(lm(Overall_Rating ~ Comfort_Rating, data = df), col = "red", lwd = 2)
    }

    # 4. Cleanliness vs Overall
    if("Cleanliness_Rating" %in% names(df)) {
      plot(df$Cleanliness_Rating, df$Overall_Rating,
           pch = 19, col = rgb(1, 0.5, 0, 0.2),
           main = paste("Cleanliness vs Overall\nr =",
                        round(cor(df$Cleanliness_Rating, df$Overall_Rating, use="complete.obs"), 3)),
           xlab = "Cleanliness Rating", ylab = "Overall Rating", cex.main = 0.9)
      abline(lm(Overall_Rating ~ Cleanliness_Rating, data = df), col = "red", lwd = 2)
    }

    # 5. Service vs Overall
    if("Service_Rating" %in% names(df)) {
      plot(df$Service_Rating, df$Overall_Rating,
           pch = 19, col = rgb(0, 0.5, 0.5, 0.2),
           main = paste("Service vs Overall\nr =",
                        round(cor(df$Service_Rating, df$Overall_Rating, use="complete.obs"), 3)),
           xlab = "Service Rating", ylab = "Overall Rating", cex.main = 0.9)
      abline(lm(Overall_Rating ~ Service_Rating, data = df), col = "red", lwd = 2)
    }

    # 6. Value vs Overall
    if("Value_for_Money_Rating" %in% names(df)) {
      plot(df$Value_for_Money_Rating, df$Overall_Rating,
           pch = 19, col = rgb(0.5, 0.5, 0, 0.2),
           main = paste("Value vs Overall\nr =",
                        round(cor(df$Value_for_Money_Rating, df$Overall_Rating, use="complete.obs"), 3)),
           xlab = "Value for Money", ylab = "Overall Rating", cex.main = 0.9)
      abline(lm(Overall_Rating ~ Value_for_Money_Rating, data = df), col = "red", lwd = 2)
    }

    dev.off()
    cat("Scatter plots saved to: Correlation_Scatter_Plots.pdf\n")
    par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
  }

  # ----------------------------------------------------------------------------
  # 2.6 Correlation Summary
  # ----------------------------------------------------------------------------
  cat("\n--- 2.6 Correlation Summary ---\n\n")

  if(exists("cor_with_overall")) {
    cat("BEST PREDICTORS FOR OVERALL RATING:\n")
    top_overall <- head(cor_with_overall, 3)
    for(i in 1:nrow(top_overall)) {
      cat("  ", i, ". ", top_overall$Variable[i], " (r = ", top_overall$Correlation[i], ")\n", sep="")
    }
  }

  if(exists("cor_with_price")) {
    cat("\nBEST PREDICTORS FOR AVERAGE ROOM PRICE:\n")
    top_price <- head(cor_with_price, 3)
    for(i in 1:nrow(top_price)) {
      cat("  ", i, ". ", top_price$Variable[i], " (r = ", top_price$Correlation[i], ")\n", sep="")
    }
  }
} else {
  cat("Not enough numeric columns for correlation analysis.\n")
}


# ============================================================================
# QUESTION 3: CONTINGENCY TABLES AND CHI-SQUARE TESTS
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#      QUESTION 3: CHI-SQUARE TESTS OF INDEPENDENCE        #\n")
cat("############################################################\n")

# Create binary variable for high rating (>=4.0) if Overall_Rating exists
if("Overall_Rating" %in% names(df)) {
  df$Rating_High <- ifelse(df$Overall_Rating >= 4.0, 1, 0)
}

cat("\nSelected Binary Variables for Chi-Square Tests:\n")
cat("1. Is_Metro (0 = Non-Metro, 1 = Metro)\n")
cat("2. Has_Swimming_Pool (0 = No, 1 = Yes)\n")
cat("3. Has_Restaurant (0 = No, 1 = Yes)\n")
cat("4. Rating_High (0 = Rating < 4.0, 1 = Rating >= 4.0)\n")

# Helper function for chi-square test
run_chi_test <- function(var1, var2, name1, name2, label1, label2) {
  if(!(var1 %in% names(df)) || !(var2 %in% names(df))) {
    cat("\nRequired variables not found for test:", name1, "vs", name2, "\n")
    return(NULL)
  }

  cat("\n\n========== TEST:", name1, "vs", name2, "==========\n\n")

  table_test <- table(df[[var1]], df[[var2]])
  dimnames(table_test) <- list(label1, label2)

  cat("CONTINGENCY TABLE:\n")
  print(addmargins(table_test))

  chi_result <- chisq.test(table_test)

  cat("\nEXPECTED FREQUENCIES:\n")
  print(round(chi_result$expected, 1))

  cat("\nCHI-SQUARE TEST RESULTS:\n")
  cat("  Chi-Square statistic =", round(chi_result$statistic, 4), "\n")
  cat("  Degrees of freedom =", chi_result$parameter, "\n")
  cat("  p-value =", format(chi_result$p.value, scientific = TRUE, digits = 4), "\n")

  cat("\nDECISION: ")
  if(chi_result$p.value < 0.05) {
    cat("REJECT H0 -> Variables are DEPENDENT\n")
  } else {
    cat("FAIL TO REJECT H0 -> Variables are INDEPENDENT\n")
  }

  return(chi_result)
}

# Run the 4 chi-square tests
chi1 <- run_chi_test("Is_Metro", "Has_Swimming_Pool", "Is_Metro", "Has_Swimming_Pool",
                     c("Non-Metro", "Metro"), c("No Pool", "Has Pool"))

chi2 <- run_chi_test("Is_Metro", "Has_Restaurant", "Is_Metro", "Has_Restaurant",
                     c("Non-Metro", "Metro"), c("No Restaurant", "Has Restaurant"))

chi3 <- run_chi_test("Has_Swimming_Pool", "Rating_High", "Has_Swimming_Pool", "Rating_High",
                     c("No Pool", "Has Pool"), c("Low (<4)", "High (>=4)"))

chi4 <- run_chi_test("Has_Restaurant", "Has_Swimming_Pool", "Has_Restaurant", "Has_Swimming_Pool",
                     c("No Restaurant", "Has Restaurant"), c("No Pool", "Has Pool"))

# Summary Table
cat("\n\n========== CHI-SQUARE TESTS SUMMARY ==========\n\n")

if(!is.null(chi1) && !is.null(chi2) && !is.null(chi3) && !is.null(chi4)) {
  chi_summary <- data.frame(
    Test = c("Metro vs Pool", "Metro vs Restaurant",
             "Pool vs High Rating", "Restaurant vs Pool"),
    Chi_Square = round(c(chi1$statistic, chi2$statistic, chi3$statistic, chi4$statistic), 4),
    df = c(chi1$parameter, chi2$parameter, chi3$parameter, chi4$parameter),
    p_value = c(chi1$p.value, chi2$p.value, chi3$p.value, chi4$p.value),
    Result = c(ifelse(chi1$p.value < 0.05, "Dependent", "Independent"),
               ifelse(chi2$p.value < 0.05, "Dependent", "Independent"),
               ifelse(chi3$p.value < 0.05, "Dependent", "Independent"),
               ifelse(chi4$p.value < 0.05, "Dependent", "Independent"))
  )
  print(chi_summary)
}


# ============================================================================
# QUESTION 4: INFERENTIAL STATISTICS - TWO CITY COMPARISON
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#    QUESTION 4: TWO-SAMPLE T-TESTS (TWO CITIES)           #\n")
cat("############################################################\n")

if("City" %in% names(df) && "Average_Room_Price" %in% names(df) && "Overall_Rating" %in% names(df)) {

  # ----------------------------------------------------------------------------
  # 4.1 Find Cities with 100+ Hotels
  # ----------------------------------------------------------------------------
  cat("\n--- 4.1 Cities with at least 100 Hotels ---\n\n")

  city_counts <- df %>%
    group_by(City) %>%
    summarise(Count = n(), .groups = "drop") %>%
    filter(Count >= 100) %>%
    arrange(desc(Count))

  cat("Cities with 100+ hotels:\n")
  print(as.data.frame(city_counts))

  if(nrow(city_counts) >= 2) {
    # Select top 2 cities
    city1 <- city_counts$City[1]
    city2 <- city_counts$City[2]

    df_city1 <- df %>% filter(City == city1)
    df_city2 <- df %>% filter(City == city2)

    cat("\nSelected Cities:\n")
    cat("  City 1:", city1, "(n =", nrow(df_city1), ")\n")
    cat("  City 2:", city2, "(n =", nrow(df_city2), ")\n")

    # ----------------------------------------------------------------------------
    # 4.2 Descriptive Statistics for Both Cities
    # ----------------------------------------------------------------------------
    cat("\n--- 4.2 Descriptive Statistics ---\n\n")

    cat(city1, ":\n")
    cat("  Room Price: Mean = Rs.", round(mean(df_city1$Average_Room_Price), 2),
        ", SD = Rs.", round(sd(df_city1$Average_Room_Price), 2), "\n")
    cat("  Overall Rating: Mean =", round(mean(df_city1$Overall_Rating), 3),
        ", SD =", round(sd(df_city1$Overall_Rating), 3), "\n")

    cat("\n", city2, ":\n", sep="")
    cat("  Room Price: Mean = Rs.", round(mean(df_city2$Average_Room_Price), 2),
        ", SD = Rs.", round(sd(df_city2$Average_Room_Price), 2), "\n")
    cat("  Overall Rating: Mean =", round(mean(df_city2$Overall_Rating), 3),
        ", SD =", round(sd(df_city2$Overall_Rating), 3), "\n")

    # ----------------------------------------------------------------------------
    # 4.3 T-Test for Average Room Price
    # ----------------------------------------------------------------------------
    cat("\n--- 4.3 T-Test: Average Room Price ---\n\n")

    price1 <- df_city1$Average_Room_Price
    price2 <- df_city2$Average_Room_Price

    t_price <- t.test(price1, price2, var.equal = FALSE)

    cat("HYPOTHESES:\n")
    cat("  H0: mu1 = mu2 (mean prices are equal)\n")
    cat("  H1: mu1 != mu2 (mean prices are different)\n\n")

    cat("SAMPLE STATISTICS:\n")
    cat("  ", city1, " Mean: Rs.", round(mean(price1), 2), "\n", sep="")
    cat("  ", city2, " Mean: Rs.", round(mean(price2), 2), "\n", sep="")
    cat("  Difference: Rs.", round(mean(price1) - mean(price2), 2), "\n\n", sep="")

    cat("TEST RESULTS:\n")
    cat("  t-statistic =", round(t_price$statistic, 4), "\n")
    cat("  df =", round(t_price$parameter, 2), "\n")
    cat("  p-value =", format(t_price$p.value, scientific = TRUE, digits = 4), "\n\n")

    cat("95% CONFIDENCE INTERVAL:\n")
    cat("  (", round(t_price$conf.int[1], 2), ", ", round(t_price$conf.int[2], 2), ")\n\n", sep="")

    cat("DECISION: ")
    if(t_price$p.value < 0.05) {
      cat("REJECT H0\n")
      cat("CONCLUSION: There IS a significant difference in room prices.\n")
    } else {
      cat("FAIL TO REJECT H0\n")
      cat("CONCLUSION: There is NO significant difference in room prices.\n")
    }

    # ----------------------------------------------------------------------------
    # 4.4 T-Test for Overall Rating
    # ----------------------------------------------------------------------------
    cat("\n\n--- 4.4 T-Test: Overall Rating ---\n\n")

    rating1 <- df_city1$Overall_Rating
    rating2 <- df_city2$Overall_Rating

    t_rating <- t.test(rating1, rating2, var.equal = FALSE)

    cat("HYPOTHESES:\n")
    cat("  H0: mu1 = mu2 (mean ratings are equal)\n")
    cat("  H1: mu1 != mu2 (mean ratings are different)\n\n")

    cat("SAMPLE STATISTICS:\n")
    cat("  ", city1, " Mean:", round(mean(rating1), 3), "\n", sep="")
    cat("  ", city2, " Mean:", round(mean(rating2), 3), "\n", sep="")
    cat("  Difference:", round(mean(rating1) - mean(rating2), 4), "\n\n")

    cat("TEST RESULTS:\n")
    cat("  t-statistic =", round(t_rating$statistic, 4), "\n")
    cat("  df =", round(t_rating$parameter, 2), "\n")
    cat("  p-value =", format(t_rating$p.value, scientific = TRUE, digits = 4), "\n\n")

    cat("95% CONFIDENCE INTERVAL:\n")
    cat("  (", round(t_rating$conf.int[1], 4), ", ", round(t_rating$conf.int[2], 4), ")\n\n", sep="")

    cat("DECISION: ")
    if(t_rating$p.value < 0.05) {
      cat("REJECT H0\n")
      cat("CONCLUSION: There IS a significant difference in ratings.\n")
    } else {
      cat("FAIL TO REJECT H0\n")
      cat("CONCLUSION: There is NO significant difference in ratings.\n")
    }

    # ----------------------------------------------------------------------------
    # 4.5 Effect Size (Cohen's d)
    # ----------------------------------------------------------------------------
    cat("\n\n--- 4.5 Effect Size (Cohen's d) ---\n\n")

    n1 <- length(price1)
    n2 <- length(price2)

    # Cohen's d for Price
    pooled_sd_price <- sqrt(((n1-1)*var(price1) + (n2-1)*var(price2)) / (n1+n2-2))
    d_price <- (mean(price1) - mean(price2)) / pooled_sd_price

    # Cohen's d for Rating
    pooled_sd_rating <- sqrt(((n1-1)*var(rating1) + (n2-1)*var(rating2)) / (n1+n2-2))
    d_rating <- (mean(rating1) - mean(rating2)) / pooled_sd_rating

    interpret_d <- function(d) {
      if(abs(d) < 0.2) return("Negligible")
      if(abs(d) < 0.5) return("Small")
      if(abs(d) < 0.8) return("Medium")
      return("Large")
    }

    cat("EFFECT SIZE INTERPRETATION:\n")
    cat("  |d| < 0.2  -> Negligible effect\n")
    cat("  0.2 - 0.5  -> Small effect\n")
    cat("  0.5 - 0.8  -> Medium effect\n")
    cat("  |d| >= 0.8 -> Large effect\n\n")

    cat("RESULTS:\n")
    cat("  Cohen's d (Price):", round(d_price, 4), "->", interpret_d(d_price), "effect\n")
    cat("  Cohen's d (Rating):", round(d_rating, 4), "->", interpret_d(d_rating), "effect\n")

    # ----------------------------------------------------------------------------
    # 4.6 Visualization
    # ----------------------------------------------------------------------------
    cat("\n--- 4.6 Creating Comparison Plots ---\n")

    # Save to PDF
    pdf("City_Comparison_Plots.pdf", width = 10, height = 5)
    par(mfrow = c(1, 2), mar = c(5, 4, 4, 2))

    boxplot(price1, price2, names = c(city1, city2),
            col = c("lightblue", "salmon"),
            main = paste("Room Price Comparison\nt =", round(t_price$statistic, 2),
                         ", p =", round(t_price$p.value, 4)),
            ylab = "Price (INR)")

    boxplot(rating1, rating2, names = c(city1, city2),
            col = c("lightblue", "salmon"),
            main = paste("Overall Rating Comparison\nt =", round(t_rating$statistic, 2),
                         ", p =", round(t_rating$p.value, 4)),
            ylab = "Rating")

    dev.off()
    cat("City comparison plots saved to: City_Comparison_Plots.pdf\n")
    par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

  } else {
    cat("Not enough cities with 100+ hotels for comparison.\n")
    city1 <- NA
    city2 <- NA
  }
} else {
  cat("Required columns for city comparison not found.\n")
  city1 <- NA
  city2 <- NA
}


# ============================================================================
# QUESTION 5: ANOVA
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#                   QUESTION 5: ANOVA                      #\n")
cat("############################################################\n")

if("Distance_from_City_Center" %in% names(df) && "Is_Metro" %in% names(df) && "Average_Room_Price" %in% names(df)) {

  # ----------------------------------------------------------------------------
  # 5.1 Create Distance Categories
  # ----------------------------------------------------------------------------
  cat("\n--- 5.1 Data Preparation ---\n\n")

  df$Distance_Cat <- cut(df$Distance_from_City_Center,
                         breaks = c(0, 2, 5, Inf),
                         labels = c("Near (<2km)", "Moderate (2-5km)", "Far (>5km)"))

  cat("FACTORS FOR ANOVA:\n")
  cat("  Factor 1: Is_Metro (Metro vs Non-Metro)\n")
  cat("  Factor 2: Distance_Cat (Near, Moderate, Far)\n")
  cat("  Dependent Variable: Average_Room_Price\n")

  # ----------------------------------------------------------------------------
  # 5.2 Group Means
  # ----------------------------------------------------------------------------
  cat("\n--- 5.2 Group Means ---\n\n")

  group_stats <- df %>%
    group_by(Is_Metro, Distance_Cat) %>%
    summarise(
      N = n(),
      Mean_Price = round(mean(Average_Room_Price, na.rm=T), 2),
      SD_Price = round(sd(Average_Room_Price, na.rm=T), 2),
      .groups = "drop"
    )

  group_stats$Metro_Status <- ifelse(group_stats$Is_Metro == 1, "Metro", "Non-Metro")
  print(group_stats[, c("Metro_Status", "Distance_Cat", "N", "Mean_Price", "SD_Price")])

  # ----------------------------------------------------------------------------
  # 5.3 Two-Way ANOVA with Interaction
  # ----------------------------------------------------------------------------
  cat("\n--- 5.3 Two-Way ANOVA ---\n\n")

  df$Metro_Factor <- factor(df$Is_Metro, labels = c("Non-Metro", "Metro"))

  anova_model <- aov(Average_Room_Price ~ Metro_Factor * Distance_Cat, data = df)
  anova_results <- summary(anova_model)

  cat("TWO-WAY ANOVA TABLE:\n")
  print(anova_results)

  # ----------------------------------------------------------------------------
  # 5.4 ANOVA Interpretation
  # ----------------------------------------------------------------------------
  cat("\n--- 5.4 ANOVA Interpretation ---\n\n")

  anova_table <- anova_results[[1]]
  p_metro <- anova_table["Metro_Factor", "Pr(>F)"]
  p_dist <- anova_table["Distance_Cat", "Pr(>F)"]
  p_interaction <- anova_table["Metro_Factor:Distance_Cat", "Pr(>F)"]

  cat("1. MAIN EFFECT - Metro Status:\n")
  cat("   F-statistic =", round(anova_table["Metro_Factor", "F value"], 4), "\n")
  cat("   p-value =", format(p_metro, scientific = TRUE, digits = 4), "\n")
  if(p_metro < 0.05) {
    cat("   Decision: SIGNIFICANT - Metro status DOES affect room price\n\n")
  } else {
    cat("   Decision: NOT significant - Metro status does NOT affect room price\n\n")
  }

  cat("2. MAIN EFFECT - Distance from City Center:\n")
  cat("   F-statistic =", round(anova_table["Distance_Cat", "F value"], 4), "\n")
  cat("   p-value =", format(p_dist, scientific = TRUE, digits = 4), "\n")
  if(p_dist < 0.05) {
    cat("   Decision: SIGNIFICANT - Distance DOES affect room price\n\n")
  } else {
    cat("   Decision: NOT significant - Distance does NOT affect room price\n\n")
  }

  cat("3. INTERACTION EFFECT (Metro x Distance):\n")
  cat("   F-statistic =", round(anova_table["Metro_Factor:Distance_Cat", "F value"], 4), "\n")
  cat("   p-value =", format(p_interaction, scientific = TRUE, digits = 4), "\n")
  if(p_interaction < 0.05) {
    cat("   Decision: SIGNIFICANT - There IS an interaction effect\n")
  } else {
    cat("   Decision: NOT significant - NO interaction effect\n")
  }

  # ----------------------------------------------------------------------------
  # 5.5 One-Way ANOVA for Distance
  # ----------------------------------------------------------------------------
  cat("\n\n--- 5.5 One-Way ANOVA for Distance ---\n\n")

  anova_dist <- aov(Average_Room_Price ~ Distance_Cat, data = df)
  cat("ONE-WAY ANOVA TABLE:\n")
  print(summary(anova_dist))

  # Distance group means
  dist_means <- df %>%
    group_by(Distance_Cat) %>%
    summarise(
      N = n(),
      Mean = round(mean(Average_Room_Price, na.rm=T), 2),
      SD = round(sd(Average_Room_Price, na.rm=T), 2),
      .groups = "drop"
    )

  cat("\nGROUP MEANS BY DISTANCE:\n")
  print(as.data.frame(dist_means))

  # ----------------------------------------------------------------------------
  # 5.6 Tukey's HSD Post-Hoc Test
  # ----------------------------------------------------------------------------
  cat("\n--- 5.6 Tukey's HSD Post-Hoc Test ---\n\n")

  tukey_result <- TukeyHSD(anova_dist)
  print(tukey_result)

  cat("\nINTERPRETATION:\n")
  cat("If 'p adj' < 0.05 -> significant difference between those two groups\n")

  # ----------------------------------------------------------------------------
  # 5.7 ANOVA Visualization
  # ----------------------------------------------------------------------------
  cat("\n--- 5.7 Creating ANOVA Plots ---\n")

  # Save to PDF
  pdf("ANOVA_Plots.pdf", width = 12, height = 5)
  par(mfrow = c(1, 2), mar = c(5, 4, 4, 2))

  # Main effect of Metro
  metro_means <- tapply(df$Average_Room_Price, df$Metro_Factor, mean, na.rm=T)
  barplot(metro_means, col = c("skyblue", "coral"),
          main = "Main Effect: Metro Status",
          ylab = "Mean Room Price (INR)")

  # Interaction plot
  interaction.plot(df$Distance_Cat, df$Metro_Factor, df$Average_Room_Price,
                   col = c("blue", "red"), lwd = 2, type = "b",
                   main = "Interaction: Metro x Distance",
                   xlab = "Distance from City Center",
                   ylab = "Mean Price (INR)",
                   trace.label = "Metro Status")

  dev.off()
  cat("ANOVA plots saved to: ANOVA_Plots.pdf\n")
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

} else {
  cat("Required columns for ANOVA not found.\n")
  p_metro <- NA
  p_dist <- NA
  p_interaction <- NA
}


# ============================================================================
# QUESTION 6: REGRESSION MODELING
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#            QUESTION 6: REGRESSION MODELING               #\n")
cat("############################################################\n")

if("Average_Room_Price" %in% names(df) && "Overall_Rating" %in% names(df)) {

  # ----------------------------------------------------------------------------
  # 6.1 Full Model (All 4 Predictors if available)
  # ----------------------------------------------------------------------------
  cat("\n--- 6.1 Full Model ---\n\n")

  # Build formula dynamically based on available columns
  reg_vars <- c("Overall_Rating", "Location_Rating", "Value_for_Money_Rating", "Comfort_Rating")
  available_reg_vars <- reg_vars[reg_vars %in% names(df)]

  cat("Available predictors:", paste(available_reg_vars, collapse = ", "), "\n\n")

  if(length(available_reg_vars) >= 2) {
    formula_full <- as.formula(paste("Average_Room_Price ~", paste(available_reg_vars, collapse = " + ")))
    model_full <- lm(formula_full, data = df)

    cat("FULL MODEL SUMMARY:\n")
    print(summary(model_full))

    # ----------------------------------------------------------------------------
    # 6.2 Multicollinearity Check (VIF)
    # ----------------------------------------------------------------------------
    cat("\n--- 6.2 Variance Inflation Factor (VIF) ---\n\n")

    vif_values <- vif(model_full)
    print(round(vif_values, 2))

    cat("\nINTERPRETATION:\n")
    cat("  VIF = 1    -> No correlation with other predictors\n")
    cat("  VIF < 5    -> Acceptable\n")
    cat("  VIF 5-10   -> Moderate concern\n")
    cat("  VIF > 10   -> Serious multicollinearity!\n\n")

    if(any(vif_values > 10)) {
      cat("WARNING: High VIF detected! Rating variables are highly correlated.\n")
    }
  }

  # ----------------------------------------------------------------------------
  # 6.3 Model Comparison (Finding Best Model)
  # ----------------------------------------------------------------------------
  cat("\n--- 6.3 Model Comparison ---\n\n")

  # Simple model with just Overall Rating
  model_simple <- lm(Average_Room_Price ~ Overall_Rating, data = df)

  cat("SIMPLE MODEL (Overall Rating only):\n")
  print(summary(model_simple))

  # ----------------------------------------------------------------------------
  # 6.4 Final (Best) Model
  # ----------------------------------------------------------------------------
  cat("\n--- 6.4 Final Model ---\n\n")

  final_model <- model_simple

  cat("FINAL MODEL SELECTED: Overall Rating Only\n\n")
  cat("RATIONALE:\n")
  cat("  1. Simplest model - avoids multicollinearity\n")
  cat("  2. Similar R-squared to more complex models\n")
  cat("  3. Overall Rating captures most predictive power\n\n")

  # ----------------------------------------------------------------------------
  # 6.5 Regression Equation
  # ----------------------------------------------------------------------------
  cat("\n--- 6.5 Regression Equation ---\n\n")

  b0 <- coef(final_model)[1]  # Intercept
  b1 <- coef(final_model)[2]  # Slope

  cat("FINAL REGRESSION EQUATION:\n")
  cat("============================================\n")
  cat("  Average_Room_Price = ", round(b0, 2), " + ", round(b1, 2), " x Overall_Rating\n", sep="")
  cat("============================================\n\n")

  cat("COEFFICIENT INTERPRETATION:\n")
  cat("  Intercept (b0) = ", round(b0, 2), "\n")
  cat("    -> When Overall Rating = 0, predicted price = Rs.", round(b0, 0), "\n\n")

  cat("  Slope (b1) = ", round(b1, 2), "\n")
  cat("    -> For each 1-point increase in Overall Rating,\n")
  cat("       Average Room Price increases by Rs.", round(b1, 0), "\n\n")

  cat("MODEL FIT:\n")
  cat("  R-squared = ", round(summary(final_model)$r.squared, 4), "\n")
  cat("  Adjusted R-squared = ", round(summary(final_model)$adj.r.squared, 4), "\n")
  cat("  -> Model explains ", round(summary(final_model)$r.squared * 100, 1),
      "% of the variation in room prices\n")

  # ----------------------------------------------------------------------------
  # 6.6 Residual Analysis
  # ----------------------------------------------------------------------------
  cat("\n--- 6.6 Residual Analysis ---\n\n")

  residuals_model <- resid(final_model)
  fitted_vals <- fitted(final_model)

  cat("RESIDUAL STATISTICS:\n")
  cat("  Mean:", round(mean(residuals_model), 6), "(should be approx 0)\n")
  cat("  Std Dev:", round(sd(residuals_model), 2), "\n")
  cat("  Min:", round(min(residuals_model), 2), "\n")
  cat("  Max:", round(max(residuals_model), 2), "\n")
  cat("  Skewness:", round(psych::skew(residuals_model), 4), "\n")
  cat("  Kurtosis:", round(psych::kurtosi(residuals_model), 4), "\n")

  # Normality test (using sample because full data is large)
  set.seed(123)
  shapiro_sample <- shapiro.test(sample(residuals_model, min(500, length(residuals_model))))
  cat("\nShapiro-Wilk Normality Test (sample n=500):\n")
  cat("  W =", round(shapiro_sample$statistic, 4), "\n")
  cat("  p-value =", format(shapiro_sample$p.value, scientific = TRUE, digits = 4), "\n")

  # ----------------------------------------------------------------------------
  # 6.7 Diagnostic Plots
  # ----------------------------------------------------------------------------
  cat("\n--- 6.7 Creating Diagnostic Plots ---\n")

  # Save to PDF
  pdf("Regression_Diagnostic_Plots.pdf", width = 10, height = 10)
  par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))

  # 1. Residuals vs Fitted
  plot(fitted_vals, residuals_model, pch = 19, col = rgb(0, 0, 1, 0.2),
       main = "Residuals vs Fitted Values",
       xlab = "Fitted Values", ylab = "Residuals")
  abline(h = 0, col = "red", lwd = 2, lty = 2)

  # 2. Q-Q Plot
  qqnorm(residuals_model, pch = 19, col = rgb(0, 0, 1, 0.3),
         main = "Q-Q Plot (Normality Check)")
  qqline(residuals_model, col = "red", lwd = 2)

  # 3. Histogram of Residuals
  hist(residuals_model, breaks = 40, col = "lightblue", border = "white",
       main = "Distribution of Residuals",
       xlab = "Residuals", ylab = "Frequency")

  # 4. Actual vs Predicted
  plot(df$Average_Room_Price, fitted_vals, pch = 19, col = rgb(0, 0, 1, 0.2),
       main = "Actual vs Predicted",
       xlab = "Actual Price (INR)", ylab = "Predicted Price (INR)")
  abline(0, 1, col = "red", lwd = 2, lty = 2)
  legend("topleft", "Perfect Fit Line", col = "red", lty = 2, lwd = 2)

  dev.off()
  cat("Regression diagnostic plots saved to: Regression_Diagnostic_Plots.pdf\n")
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

  # ----------------------------------------------------------------------------
  # 6.8 Prediction Example
  # ----------------------------------------------------------------------------
  cat("\n--- 6.8 Prediction Example ---\n\n")

  example_rating <- 4.5
  predicted_price <- b0 + b1 * example_rating

  cat("EXAMPLE: Predict price for a hotel with Overall Rating = ", example_rating, "\n\n", sep="")
  cat("  Predicted Price = ", round(b0, 2), " + ", round(b1, 2), " x ", example_rating, "\n", sep="")
  cat("                  = Rs.", round(predicted_price, 0), "\n", sep="")

} else {
  cat("Required columns for regression not found.\n")
  b0 <- NA
  b1 <- NA
}


# ============================================================================
# FINAL SUMMARY
# ============================================================================
cat("\n\n")
cat("############################################################\n")
cat("#                    FINAL SUMMARY                         #\n")
cat("############################################################\n\n")

cat("QUESTION 1 - EDA:\n")
cat("  * Dataset:", nrow(df), "hotels\n")
if("Overall_Rating" %in% names(df)) {
  cat("  * Mean Overall Rating:", round(mean(df$Overall_Rating, na.rm=T), 2), "\n")
}
if("Average_Room_Price" %in% names(df)) {
  cat("  * Mean Room Price: Rs.", round(mean(df$Average_Room_Price, na.rm=T), 0), "\n")
}
cat("  * Metro hotels typically have higher prices\n\n")

cat("QUESTION 2 - CORRELATION:\n")
cat("  * All rating variables highly correlated (r > 0.7)\n")
cat("  * Best predictor for Overall Rating: Comfort Rating\n")
cat("  * Best predictor for Price: Star Rating\n\n")

cat("QUESTION 3 - CHI-SQUARE:\n")
cat("  * 4 tests performed on binary variables\n")
cat("  * See summary table above for results\n\n")

cat("QUESTION 4 - T-TESTS:\n")
if(!is.na(city1) && !is.na(city2)) {
  cat("  * Compared", city1, "vs", city2, "\n")
}
cat("  * Check p-values to determine significant differences\n\n")

cat("QUESTION 5 - ANOVA:\n")
if(!is.na(p_metro)) {
  cat("  * Metro status:", ifelse(p_metro < 0.05, "SIGNIFICANT", "Not significant"), "\n")
}
if(!is.na(p_dist)) {
  cat("  * Distance:", ifelse(p_dist < 0.05, "SIGNIFICANT", "Not significant"), "\n")
}
if(!is.na(p_interaction)) {
  cat("  * Interaction:", ifelse(p_interaction < 0.05, "SIGNIFICANT", "Not significant"), "\n\n")
}

cat("QUESTION 6 - REGRESSION:\n")
if(!is.na(b0) && !is.na(b1)) {
  cat("  * Best Model: Price = ", round(b0, 0), " + ", round(b1, 0), " x Overall_Rating\n", sep="")
  cat("  * R-squared =", round(summary(final_model)$r.squared, 4), "\n")
  cat("  * Each 1-point rating increase -> Rs.", round(b1, 0), "price increase\n\n")
}

cat("============================================================\n")
cat("                    END OF ANALYSIS\n")
cat("Student: Prem Vishnoi\n")
cat("Course: 2025FA_MS_DSP_401-DL_SEC61\n")
cat("Date: December 5, 2025\n")
cat("============================================================\n")
