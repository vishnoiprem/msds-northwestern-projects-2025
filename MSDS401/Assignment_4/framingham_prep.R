# ============================================================================
# FRAMINGHAM HEART STUDY - CORRECTED DATA PREPARATION
# For: Prem Vishnoi - Assignment 4
# FIXED: Handles missing values properly (hdlc/ldlc were 100% missing!)
# ============================================================================

# Set working directory
setwd("/Users/pvishnoi/PycharmProjects/msds-northwestern-projects-2025/MSDS401/Assignment_4")

# Load required libraries
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# ============================================================================
# STEP 1: Load the Data
# ============================================================================

cat("\n=== LOADING FRAMINGHAM DATA ===\n")

# Load the data
framingham_raw <- read_excel("framinghamHeartStudy_data.xlsx")

cat("Original dataset loaded:\n")
cat("  Rows:", nrow(framingham_raw), "\n")
cat("  Columns:", ncol(framingham_raw), "\n\n")

cat("Column names preview:\n")
print(head(names(framingham_raw), 20))

# ============================================================================
# STEP 2: Keep Only Time Point 1 Variables (and outcome variables)
# ============================================================================
# Per assignment: Remove variables ending in '2' or '3'

cat("\n=== REMOVING TIME POINT 2 AND 3 VARIABLES ===\n")

# Identify columns to KEEP
# Keep: variables ending in '1', outcome variables (no numbers), and TIME variables initially
cols_to_keep <- names(framingham_raw)[
  !grepl("[23]$", names(framingham_raw)) |
  names(framingham_raw) == "randid"
]

framingham_reduced <- framingham_raw[, cols_to_keep]

cat("Original columns:", ncol(framingham_raw), "\n")
cat("After removing '2' and '3' variables:", ncol(framingham_reduced), "\n")
cat("Removed:", ncol(framingham_raw) - ncol(framingham_reduced), "variables\n")

# ============================================================================
# STEP 3: Remove TIME Variables
# ============================================================================

cat("\n=== REMOVING TIME VARIABLES ===\n")

time_vars <- grep("^time", names(framingham_reduced), ignore.case = TRUE, value = TRUE)
cat("TIME variables to remove:\n")
print(time_vars)

framingham_clean <- framingham_reduced %>%
  select(-starts_with("time", ignore.case = TRUE))

cat("\nAfter removing TIME variables:", ncol(framingham_clean), "columns\n")

# ============================================================================
# STEP 4: Rename Variables (Remove the '1' suffix for clarity)
# ============================================================================

cat("\n=== RENAMING VARIABLES (removing '1' suffix) ===\n")

# Create a mapping of old to new names
old_names <- names(framingham_clean)
new_names <- gsub("1$", "", old_names)  # Remove trailing '1'

# Rename the columns
names(framingham_clean) <- new_names

cat("Variables renamed. Example:\n")
cat("  sex1 -> sex\n")
cat("  age1 -> age\n")
cat("  sysbp1 -> sysbp\n")

# ============================================================================
# STEP 5: Check for Missing Values (CORRECTED!)
# ============================================================================

cat("\n=== CHECKING MISSING VALUES ===\n")

missing_summary <- sapply(framingham_clean, function(x) sum(is.na(x)))
vars_with_missing <- missing_summary[missing_summary > 0]

if(length(vars_with_missing) > 0) {
  cat("Variables with missing values:\n")
  print(vars_with_missing)
  cat("\nMissing percentages:\n")
  missing_pct <- round(100 * vars_with_missing / nrow(framingham_clean), 1)
  print(missing_pct)
}

cat("\nComplete cases (across ALL variables):", sum(complete.cases(framingham_clean)),
    "out of", nrow(framingham_clean), "\n")

# ============ CRITICAL FIX ============
# Remove columns that are entirely or almost entirely missing
# These variables can't be used for analysis anyway
cols_mostly_missing <- names(missing_summary[missing_summary > 0.95 * nrow(framingham_clean)])

if(length(cols_mostly_missing) > 0) {
  cat("\n🔧 REMOVING COLUMNS WITH >95% MISSING DATA:\n")
  print(cols_mostly_missing)
  framingham_clean <- framingham_clean %>%
    select(-all_of(cols_mostly_missing))
}

# Now check which core variables we need for analysis
# We'll keep rows that have complete data for the ESSENTIAL variables
essential_vars <- c("sex", "age", "sysbp", "diabp", "totchol",
                   "cursmoke", "diabetes",
                   "anychd", "mi_fchd", "hospmi", "angina",
                   "stroke", "cvd", "hyperten", "death",
                   "prevchd", "prevap", "prevmi", "prevstrk", "prevhyp")

cat("\n🔧 FILTERING FOR COMPLETE ESSENTIAL VARIABLES...\n")
cat("Essential variables:", paste(essential_vars, collapse=", "), "\n")

framingham_complete <- framingham_clean %>%
  filter(if_all(all_of(essential_vars), ~ !is.na(.)))

cat("\n✓ After filtering:", nrow(framingham_complete), "rows retained\n")
cat("  Rows removed:", nrow(framingham_clean) - nrow(framingham_complete),
    "(", round(100*(nrow(framingham_clean) - nrow(framingham_complete))/nrow(framingham_clean), 1), "%)\n")

# Keep track of which variables still have missing values in the complete dataset
remaining_missing <- sapply(framingham_complete, function(x) sum(is.na(x)))
remaining_missing <- remaining_missing[remaining_missing > 0]
if(length(remaining_missing) > 0) {
  cat("\nVariables with remaining missing values (OK - not essential):\n")
  print(remaining_missing)
}

# ============================================================================
# STEP 6: Verify Binary Variables (Should already be 0/1)
# ============================================================================

cat("\n=== VERIFYING BINARY VARIABLES ===\n")

# These should already be 0/1 coded
binary_vars <- c("death", "angina", "hospmi", "mi_fchd", "anychd",
                 "stroke", "cvd", "hyperten",
                 "cursmoke", "diabetes", "bpmeds",
                 "prevchd", "prevap", "prevmi", "prevstrk", "prevhyp")

cat("Checking binary variables:\n")
for(var in binary_vars) {
  if(var %in% names(framingham_complete)) {
    unique_vals <- sort(unique(framingham_complete[[var]]))
    cat(sprintf("  %-12s: %s\n", var, paste(unique_vals, collapse = ", ")))
  }
}

# ============================================================================
# STEP 7: Create Derived Variables
# ============================================================================

cat("\n=== CREATING DERIVED VARIABLES ===\n")

# First, ensure all numeric variables are actually numeric
framingham_complete <- framingham_complete %>%
  mutate(
    # Convert to numeric if needed
    age = as.numeric(age),
    bmi = as.numeric(bmi),
    sysbp = as.numeric(sysbp),
    totchol = as.numeric(totchol),
    sex = as.numeric(sex),
    cursmoke = as.numeric(cursmoke),
    diabetes = as.numeric(diabetes)
  )

# Now create derived variables
framingham_complete <- framingham_complete %>%
  mutate(
    # Age groups
    age_group = cut(age,
                    breaks = c(0, 40, 50, 60, 70, 100),
                    labels = c("<40", "40-50", "50-60", "60-70", "70+"),
                    right = FALSE),

    # BMI categories (handle missing BMI)
    bmi_category = cut(bmi,
                      breaks = c(0, 18.5, 25, 30, 100),
                      labels = c("Underweight", "Normal", "Overweight", "Obese"),
                      right = FALSE),

    # Blood pressure categories (based on systolic)
    bp_category = cut(sysbp,
                     breaks = c(0, 120, 140, 160, 300),
                     labels = c("Normal", "Elevated", "Stage1_HTN", "Stage2_HTN"),
                     right = FALSE),

    # Cholesterol categories
    chol_category = cut(totchol,
                       breaks = c(0, 200, 240, 1000),
                       labels = c("Desirable", "Borderline", "High"),
                       right = FALSE),

    # Sex as factor with labels
    sex_label = factor(sex, levels = c(1, 2), labels = c("Male", "Female")),

    # Smoking status as factor
    smoking_status = factor(cursmoke, levels = c(0, 1),
                           labels = c("Non-smoker", "Current smoker")),

    # Diabetes as factor
    diabetes_status = factor(diabetes, levels = c(0, 1),
                            labels = c("Non-diabetic", "Diabetic")),

    # CVD risk score (simple example - not clinically validated)
    risk_score = (as.numeric(age) - 30) * 0.1 +
                 (as.numeric(sysbp) - 120) * 0.05 +
                 (as.numeric(totchol) - 200) * 0.01 +
                 as.numeric(cursmoke) * 5 +
                 as.numeric(diabetes) * 10
  )

cat("Derived variables created:\n")
cat("  - age_group\n")
cat("  - bmi_category\n")
cat("  - bp_category\n")
cat("  - chol_category\n")
cat("  - sex_label\n")
cat("  - smoking_status\n")
cat("  - diabetes_status\n")
cat("  - risk_score (simple CVD risk score)\n")

# ============================================================================
# STEP 8: Save Clean Dataset
# ============================================================================

cat("\n=== SAVING CLEAN DATASET ===\n")

# Save in multiple formats
saveRDS(framingham_complete, "FHS_assign4_prem_vishnoi.rds")
write.csv(framingham_complete, "FHS_assign4_prem_vishnoi.csv", row.names = FALSE)

# Also save the version with missing data (for sensitivity analyses)
saveRDS(framingham_clean, "FHS_assign4_vishnoi_with_missing.rds")

cat("Files saved:\n")
cat("  - FHS_assign4_prem_vishnoi.rds (complete cases only)\n")
cat("  - FHS_assign4_prem_vishnoi.csv (complete cases, CSV format)\n")
cat("  - FHS_assign4_vishnoi_with_missing.rds (all cases)\n")

# ============================================================================
# STEP 9: Comprehensive Summary Statistics
# ============================================================================

cat("\n\n")
cat("============================================================\n")
cat("  FINAL DATASET SUMMARY\n")
cat("============================================================\n\n")

cat("Dataset Dimensions:\n")
cat("  Total participants:", nrow(framingham_complete), "\n")
cat("  Variables:", ncol(framingham_complete), "\n\n")

cat("DEMOGRAPHIC CHARACTERISTICS:\n")
cat("----------------------------\n")
cat(sprintf("  Age: %.1f ± %.1f years (range: %.0f-%.0f)\n",
            mean(framingham_complete$age),
            sd(framingham_complete$age),
            min(framingham_complete$age),
            max(framingham_complete$age)))

sex_table <- table(framingham_complete$sex)
cat(sprintf("  Sex: Male: %d (%.1f%%), Female: %d (%.1f%%)\n",
            sex_table[1], 100*sex_table[1]/sum(sex_table),
            sex_table[2], 100*sex_table[2]/sum(sex_table)))

cat("\nCLINICAL MEASUREMENTS (Mean ± SD):\n")
cat("----------------------------------\n")

# Handle BMI which might have missing values
if(sum(!is.na(framingham_complete$bmi)) > 0) {
  cat(sprintf("  BMI: %.1f ± %.1f kg/m² (n=%d)\n",
              mean(framingham_complete$bmi, na.rm=TRUE),
              sd(framingham_complete$bmi, na.rm=TRUE),
              sum(!is.na(framingham_complete$bmi))))
}

cat(sprintf("  Systolic BP: %.1f ± %.1f mmHg\n",
            mean(framingham_complete$sysbp), sd(framingham_complete$sysbp)))
cat(sprintf("  Diastolic BP: %.1f ± %.1f mmHg\n",
            mean(framingham_complete$diabp), sd(framingham_complete$diabp)))
cat(sprintf("  Total Cholesterol: %.1f ± %.1f mg/dL\n",
            mean(framingham_complete$totchol), sd(framingham_complete$totchol)))

# Handle optional variables that might have missing values
if("glucose" %in% names(framingham_complete) && sum(!is.na(framingham_complete$glucose)) > 0) {
  cat(sprintf("  Glucose: %.1f ± %.1f mg/dL (n=%d)\n",
              mean(framingham_complete$glucose, na.rm=TRUE),
              sd(framingham_complete$glucose, na.rm=TRUE),
              sum(!is.na(framingham_complete$glucose))))
}

if("heartrte" %in% names(framingham_complete) && sum(!is.na(framingham_complete$heartrte)) > 0) {
  cat(sprintf("  Heart Rate: %.1f ± %.1f bpm (n=%d)\n",
              mean(framingham_complete$heartrte, na.rm=TRUE),
              sd(framingham_complete$heartrte, na.rm=TRUE),
              sum(!is.na(framingham_complete$heartrte))))
}

cat("\nRISK FACTORS (Prevalence %):\n")
cat("----------------------------\n")
cat(sprintf("  Current Smokers: %.1f%%\n", 100*mean(framingham_complete$cursmoke)))
cat(sprintf("  Diabetes: %.1f%%\n", 100*mean(framingham_complete$diabetes)))

if("bpmeds" %in% names(framingham_complete) && sum(!is.na(framingham_complete$bpmeds)) > 0) {
  cat(sprintf("  On BP Medication: %.1f%% (n=%d)\n",
              100*mean(framingham_complete$bpmeds, na.rm=TRUE),
              sum(!is.na(framingham_complete$bpmeds))))
}

cat("\nPREVALENT CONDITIONS at Baseline (%):\n")
cat("-------------------------------------\n")
cat(sprintf("  Coronary Heart Disease: %.1f%%\n", 100*mean(framingham_complete$prevchd)))
cat(sprintf("  Angina Pectoris: %.1f%%\n", 100*mean(framingham_complete$prevap)))
cat(sprintf("  Myocardial Infarction: %.1f%%\n", 100*mean(framingham_complete$prevmi)))
cat(sprintf("  Stroke: %.1f%%\n", 100*mean(framingham_complete$prevstrk)))
cat(sprintf("  Hypertension: %.1f%%\n", 100*mean(framingham_complete$prevhyp)))

cat("\nINCIDENT EVENTS During Follow-up (%):\n")
cat("-------------------------------------\n")
cat(sprintf("  Any CHD: %.1f%%\n", 100*mean(framingham_complete$anychd)))
cat(sprintf("  MI or Fatal CHD: %.1f%%\n", 100*mean(framingham_complete$mi_fchd)))
cat(sprintf("  Hospitalized MI: %.1f%%\n", 100*mean(framingham_complete$hospmi)))
cat(sprintf("  Angina: %.1f%%\n", 100*mean(framingham_complete$angina)))
cat(sprintf("  Stroke: %.1f%%\n", 100*mean(framingham_complete$stroke)))
cat(sprintf("  CVD: %.1f%%\n", 100*mean(framingham_complete$cvd)))
cat(sprintf("  Incident Hypertension: %.1f%%\n", 100*mean(framingham_complete$hyperten)))
cat(sprintf("  Death: %.1f%%\n", 100*mean(framingham_complete$death)))

# ============================================================================
# STEP 10: Variable List for Analysis
# ============================================================================

cat("\n\n")
cat("============================================================\n")
cat("  VARIABLES AVAILABLE FOR ANALYSIS\n")
cat("============================================================\n\n")

cat("DEMOGRAPHIC:\n")
cat("  - randid (unique ID)\n")
cat("  - sex (1=Male, 2=Female)\n")
cat("  - age (years)\n")
cat("  - age_group (<40, 40-50, 50-60, 60-70, 70+)\n")
cat("  - sex_label (Male/Female)\n")

cat("\nCLINICAL MEASUREMENTS:\n")
cat("  - sysbp (Systolic BP, mmHg)\n")
cat("  - diabp (Diastolic BP, mmHg)\n")
if("bmi" %in% names(framingham_complete)) cat("  - bmi (Body Mass Index, kg/m²)\n")
if("heartrte" %in% names(framingham_complete)) cat("  - heartrte (Heart rate, bpm)\n")
cat("  - totchol (Total cholesterol, mg/dL)\n")
if("glucose" %in% names(framingham_complete)) cat("  - glucose (Glucose, mg/dL)\n")

cat("\nRISK FACTORS (Binary: 0=No, 1=Yes):\n")
cat("  - cursmoke (Current smoker)\n")
if("cigpday" %in% names(framingham_complete)) cat("  - cigpday (Cigarettes per day)\n")
cat("  - diabetes (Diabetic)\n")
if("bpmeds" %in% names(framingham_complete)) cat("  - bpmeds (On BP medication)\n")
cat("  - smoking_status (factor: Non-smoker/Current smoker)\n")
cat("  - diabetes_status (factor: Non-diabetic/Diabetic)\n")

cat("\nPREVALENT CONDITIONS (Binary: 0=No, 1=Yes):\n")
cat("  - prevchd (Prevalent CHD)\n")
cat("  - prevap (Prevalent angina)\n")
cat("  - prevmi (Prevalent MI)\n")
cat("  - prevstrk (Prevalent stroke)\n")
cat("  - prevhyp (Prevalent hypertension)\n")

cat("\nOUTCOME VARIABLES (Binary: 0=No, 1=Yes):\n")
cat("  - anychd (Any CHD event)\n")
cat("  - mi_fchd (MI or fatal CHD)\n")
cat("  - hospmi (Hospitalized MI)\n")
cat("  - angina (Angina pectoris)\n")
cat("  - stroke (Stroke event)\n")
cat("  - cvd (Cardiovascular disease)\n")
cat("  - hyperten (Incident hypertension)\n")
cat("  - death (Death from any cause)\n")

cat("\nDERIVED VARIABLES:\n")
cat("  - bmi_category (Underweight/Normal/Overweight/Obese)\n")
cat("  - bp_category (Normal/Elevated/Stage1_HTN/Stage2_HTN)\n")
cat("  - chol_category (Desirable/Borderline/High)\n")
cat("  - risk_score (Simple CVD risk score)\n")

# ============================================================================
# STEP 11: Quick Data Quality Checks
# ============================================================================

cat("\n\n")
cat("============================================================\n")
cat("  DATA QUALITY CHECKS\n")
cat("============================================================\n\n")

# Check for outliers
cat("Potential Outliers (values beyond 3 SD from mean):\n")
cat("---------------------------------------------------\n")

check_outliers <- function(x, varname) {
  if(sum(!is.na(x)) > 0) {
    mean_val <- mean(x, na.rm = TRUE)
    sd_val <- sd(x, na.rm = TRUE)
    outliers <- sum(abs(x - mean_val) > 3 * sd_val, na.rm = TRUE)
    if(outliers > 0) {
      cat(sprintf("  %s: %d outliers\n", varname, outliers))
    }
  }
}

check_outliers(framingham_complete$age, "Age")
check_outliers(framingham_complete$sysbp, "Systolic BP")
check_outliers(framingham_complete$diabp, "Diastolic BP")
if("bmi" %in% names(framingham_complete)) check_outliers(framingham_complete$bmi, "BMI")
check_outliers(framingham_complete$totchol, "Total Cholesterol")
if("glucose" %in% names(framingham_complete)) check_outliers(framingham_complete$glucose, "Glucose")

# ============================================================================
# SCRIPT COMPLETE
# ============================================================================

cat("\n\n")
cat("============================================================\n")
cat("  ✓ DATA PREPARATION COMPLETE!\n")
cat("============================================================\n\n")

cat("Your clean dataset is ready:\n")
cat("  - In memory as: framingham_complete\n")
cat("  - Saved as: FHS_assign4_prem_vishnoi.rds\n")
cat("  - Also saved as: FHS_assign4_prem_vishnoi.csv\n\n")

cat("To reload later:\n")
cat("  mydata <- readRDS('FHS_assign4_prem_vishnoi.rds')\n\n")

cat("Next step: Open framingham_analysis.Rmd for your analysis!\n")
cat("============================================================\n\n")

# Display first few rows
cat("First 5 rows of key variables:\n")
key_vars <- c("randid", "sex", "age", "sysbp", "diabp",
              "totchol", "cursmoke", "diabetes",
              "anychd", "cvd", "death")
# Only include variables that exist
key_vars <- key_vars[key_vars %in% names(framingham_complete)]
print(head(framingham_complete[, key_vars], 5))
