# ============================================================================
# Framingham Heart Study Data - Assignment 4 Preparation
# ============================================================================
# This script performs all data cleaning and preparation steps for the 
# Framingham Heart Study analysis assignment
# ============================================================================

# Load required libraries
library(readxl)    # For reading Excel files
library(dplyr)     # For data manipulation
library(tidyr)     # For data tidying
library(ggplot2)   # For visualization
library(corrplot)  # For correlation plots

# ============================================================================
# STEP 1: Load the Data
# ============================================================================
# Set your working directory to where you saved the Framingham data
# setwd("C:/Your/Path/Here")

# Read the Framingham data
# Replace 'framingham.xlsx' with your actual filename
framingham_raw <- read_excel("framingham.xlsx")

# View the structure of the data
cat("Original dataset dimensions:", dim(framingham_raw), "\n")
str(framingham_raw)

# ============================================================================
# STEP 2: Remove Time Point 2 and 3 Variables
# ============================================================================
# Remove all variables ending in '2' or '3'
# Also remove variables starting with 'TIME'

# Get column names
col_names <- names(framingham_raw)

# Identify columns to keep (NOT ending in 2 or 3, NOT starting with TIME)
cols_to_keep <- col_names[!grepl("[23]$", col_names) & 
                           !grepl("^TIME", col_names, ignore.case = TRUE)]

# Create reduced dataset
framingham_reduced <- framingham_raw[, cols_to_keep]

cat("\nReduced dataset dimensions:", dim(framingham_reduced), "\n")
cat("Variables removed:", length(col_names) - length(cols_to_keep), "\n")

# ============================================================================
# STEP 3: Handle Missing Values
# ============================================================================
# Check for missing values
missing_summary <- sapply(framingham_reduced, function(x) sum(is.na(x)))
cat("\nMissing values per variable:\n")
print(missing_summary[missing_summary > 0])

# Count complete cases
complete_cases <- sum(complete.cases(framingham_reduced))
cat("\nComplete cases:", complete_cases, "out of", nrow(framingham_reduced), "\n")

# Remove rows with any missing values
framingham_clean <- framingham_reduced[complete.cases(framingham_reduced), ]

cat("Dataset after removing missing values:", dim(framingham_clean), "\n")

# ============================================================================
# STEP 4: Recode Yes/No Variables to 1/0
# ============================================================================
# Identify character/factor columns (likely Yes/No variables)
char_cols <- sapply(framingham_clean, function(x) is.character(x) | is.factor(x))
char_col_names <- names(framingham_clean)[char_cols]

cat("\nCharacter/Factor variables found:\n")
print(char_col_names)

# Function to recode Yes/No to 1/0
recode_yes_no <- function(x) {
  ifelse(tolower(trimws(x)) == 'yes', 1, 
         ifelse(tolower(trimws(x)) == 'no', 0, 99))
}

# Create new binary variables for Yes/No columns
for(col in char_col_names) {
  # Check if variable contains Yes/No values
  unique_vals <- unique(tolower(trimws(framingham_clean[[col]])))
  
  if(all(unique_vals %in% c('yes', 'no', NA))) {
    # Create new binary variable with 'd_' prefix
    new_col_name <- paste0("d_", tolower(col))
    framingham_clean[[new_col_name]] <- recode_yes_no(framingham_clean[[col]])
    
    # Print recoding summary
    cat("\nRecoded", col, "to", new_col_name, ":\n")
    print(table(framingham_clean[[col]], framingham_clean[[new_col_name]], 
                useNA = "always"))
    
    # Check for any 99 values (invalid data)
    if(any(framingham_clean[[new_col_name]] == 99, na.rm = TRUE)) {
      warning(paste("Variable", new_col_name, "contains invalid values (99)"))
    }
  }
}

# ============================================================================
# STEP 5: Data Type Conversions
# ============================================================================
# Ensure numeric variables are properly coded
# Example: Convert any remaining character numbers to numeric

numeric_candidates <- names(framingham_clean)[sapply(framingham_clean, is.character)]
for(col in numeric_candidates) {
  # Skip if already recoded as binary
  if(!col %in% char_col_names) {
    # Try to convert to numeric
    test_numeric <- suppressWarnings(as.numeric(framingham_clean[[col]]))
    if(!all(is.na(test_numeric))) {
      framingham_clean[[col]] <- test_numeric
    }
  }
}

# ============================================================================
# STEP 6: Save the Clean Dataset
# ============================================================================
# Save as RDS (R native format - preserves data types)
saveRDS(framingham_clean, "FHS_assign4.rds")

# Save as CSV (for easy viewing/sharing)
write.csv(framingham_clean, "FHS_assign4.csv", row.names = FALSE)

cat("\n\nClean dataset saved as:\n")
cat("  - FHS_assign4.rds (R format)\n")
cat("  - FHS_assign4.csv (CSV format)\n")

# ============================================================================
# STEP 7: Basic Exploratory Data Analysis (EDA)
# ============================================================================
cat("\n\n======== EXPLORATORY DATA ANALYSIS ========\n")

# Summary statistics
cat("\nSummary Statistics:\n")
print(summary(framingham_clean))

# Dataset structure
cat("\nDataset Structure:\n")
str(framingham_clean)

# Dimensions
cat("\nFinal dataset dimensions:", dim(framingham_clean), "\n")
cat("  Rows (observations):", nrow(framingham_clean), "\n")
cat("  Columns (variables):", ncol(framingham_clean), "\n")

# Variable names
cat("\nVariable names:\n")
print(names(framingham_clean))

# ============================================================================
# STEP 8: Create Visualizations for Numeric Variables
# ============================================================================
# Select numeric columns only
numeric_cols <- sapply(framingham_clean, is.numeric)
numeric_data <- framingham_clean[, numeric_cols]

# Create output directory for plots
if(!dir.exists("plots")) dir.create("plots")

# Histograms for key variables
key_vars <- c("AGE1", "SYSBP1", "DIABP1", "BMI1", "HEARTRTE1", "GLUCOSE1")
existing_vars <- key_vars[key_vars %in% names(numeric_data)]

if(length(existing_vars) > 0) {
  pdf("plots/histograms.pdf", width = 12, height = 8)
  par(mfrow = c(2, 3))
  for(var in existing_vars) {
    hist(numeric_data[[var]], 
         main = paste("Distribution of", var),
         xlab = var,
         col = "steelblue",
         border = "white")
  }
  dev.off()
  cat("\nHistograms saved to plots/histograms.pdf\n")
}

# ============================================================================
# STEP 9: Correlation Analysis (for numeric variables)
# ============================================================================
# Calculate correlation matrix (excluding binary coded variables)
non_binary_numeric <- numeric_data[, !grepl("^d_", names(numeric_data))]

if(ncol(non_binary_numeric) > 1) {
  cor_matrix <- cor(non_binary_numeric, use = "complete.obs")
  
  # Save correlation plot
  pdf("plots/correlation_plot.pdf", width = 10, height = 10)
  corrplot(cor_matrix, 
           method = "color",
           type = "upper",
           tl.cex = 0.7,
           tl.col = "black",
           title = "Correlation Matrix of Numeric Variables",
           mar = c(0,0,2,0))
  dev.off()
  cat("Correlation plot saved to plots/correlation_plot.pdf\n")
  
  # Print high correlations (> 0.7 or < -0.7)
  high_cor <- which(abs(cor_matrix) > 0.7 & cor_matrix != 1, arr.ind = TRUE)
  if(nrow(high_cor) > 0) {
    cat("\nHigh correlations found (|r| > 0.7):\n")
    for(i in 1:nrow(high_cor)) {
      row_idx <- high_cor[i, 1]
      col_idx <- high_cor[i, 2]
      if(row_idx < col_idx) {  # Avoid duplicates
        cat(sprintf("  %s vs %s: %.3f\n", 
                    rownames(cor_matrix)[row_idx],
                    colnames(cor_matrix)[col_idx],
                    cor_matrix[row_idx, col_idx]))
      }
    }
  }
}

# ============================================================================
# STEP 10: Create Analysis-Ready Dataset in R Environment
# ============================================================================
# Load the clean data (if starting fresh)
# mydata <- readRDS("FHS_assign4.rds")
# Or simply use the framingham_clean object already in memory

cat("\n\n======== DATA PREPARATION COMPLETE ========\n")
cat("Your analysis-ready dataset is available as 'framingham_clean'\n")
cat("To load it later, use: mydata <- readRDS('FHS_assign4.rds')\n")

# ============================================================================
# STEP 11: Data Quality Checks
# ============================================================================
cat("\n\n======== DATA QUALITY CHECKS ========\n")

# Check for any remaining invalid values (99) in binary variables
binary_vars <- names(framingham_clean)[grepl("^d_", names(framingham_clean))]
if(length(binary_vars) > 0) {
  cat("\nBinary variable value checks:\n")
  for(var in binary_vars) {
    unique_vals <- unique(framingham_clean[[var]])
    if(any(unique_vals == 99)) {
      warning(paste(var, "contains invalid values (99)"))
    }
    cat(sprintf("  %s: %s\n", var, paste(unique_vals, collapse = ", ")))
  }
}

# Check for outliers in numeric variables
check_outliers <- function(x, var_name) {
  if(is.numeric(x)) {
    Q1 <- quantile(x, 0.25, na.rm = TRUE)
    Q3 <- quantile(x, 0.75, na.rm = TRUE)
    IQR <- Q3 - Q1
    lower_bound <- Q1 - 3 * IQR
    upper_bound <- Q3 + 3 * IQR
    outliers <- sum(x < lower_bound | x > upper_bound, na.rm = TRUE)
    if(outliers > 0) {
      cat(sprintf("  %s: %d potential outliers\n", var_name, outliers))
    }
  }
}

cat("\nPotential outliers (beyond 3*IQR):\n")
for(col in names(numeric_data)) {
  check_outliers(numeric_data[[col]], col)
}

cat("\n======== SCRIPT COMPLETE ========\n")
cat("You are ready to begin your analysis!\n")
