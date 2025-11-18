# ============================================================================
# QUICK START GUIDE - CORRECTED FOR YOUR DATA
# ============================================================================

# YOUR DATA STRUCTURE:
# -------------------
# Your Framingham data has variables with suffixes: 1, 2, 3
# Example: sex1, sex2, sex3 (for three time points)
# You need: ONLY the "1" variables (baseline exam)

# ============================================================================
# STEP 1: INSTALL PACKAGES (FIRST TIME ONLY)
# ============================================================================

# Run this ONCE:
install.packages(c("readxl", "dplyr", "tidyr", "ggplot2", 
                   "corrplot", "knitr", "rmarkdown", "gridExtra"))

# ============================================================================
# STEP 2: SET WORKING DIRECTORY
# ============================================================================

setwd("/Users/pvishnoi/PycharmProjects/msds-northwestern-projects-2025/MSDS401/Assignment_4")

# Verify you're in the right place:
getwd()
list.files()  # Should show your .xlsx file

# ============================================================================
# STEP 3: RUN THE CORRECT PREPARATION SCRIPT
# ============================================================================

# Load libraries
library(readxl)
library(dplyr)

# Run the CORRECT preparation script:
source("framingham_prep.R")

# This will:
# 1. Load your data
# 2. Remove variables ending in '2' and '3'
# 3. Remove TIME variables
# 4. Rename variables (remove '1' suffix)
# 5. Handle missing values
# 6. Create derived variables
# 7. Save clean dataset

# ============================================================================
# STEP 4: YOUR DATA IS NOW READY!
# ============================================================================

# The clean dataset is called: framingham_complete
# It's also saved as: FHS_assign4_vishnoi.rds

# To load it later:
# mydata <- readRDS("FHS_assign4_vishnoi.rds")

# ============================================================================
# STEP 5: START YOUR ANALYSIS
# ============================================================================

# Quick look at your data:
head(framingham_complete)
summary(framingham_complete)

# Example analyses:

# 1. Descriptive statistics by sex
framingham_complete %>%
  group_by(sex_label) %>%
  summarise(
    n = n(),
    mean_age = mean(age),
    mean_bmi = mean(bmi),
    mean_sysbp = mean(sysbp)
  )

# 2. CHD prevalence by age group
framingham_complete %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    chd_cases = sum(anychd),
    prevalence = mean(anychd) * 100
  )

# 3. Simple visualization
library(ggplot2)

ggplot(framingham_complete, aes(x = age, y = sysbp)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Systolic BP vs Age",
       x = "Age (years)",
       y = "Systolic BP (mmHg)") +
  theme_minimal()

# 4. T-test: Age by CHD status
t.test(age ~ anychd, data = framingham_complete)

# 5. Simple linear regression
model <- lm(sysbp ~ age + bmi + sex, data = framingham_complete)
summary(model)

# 6. Logistic regression for CHD
logit_model <- glm(anychd ~ age + sysbp + bmi + cursmoke + diabetes, 
                   data = framingham_complete, 
                   family = binomial)
summary(logit_model)

# Odds ratios:
exp(coef(logit_model))

# ============================================================================
# COMMON VARIABLES IN YOUR DATA:
# ============================================================================

# DEMOGRAPHICS:
#   - sex (1=Male, 2=Female)
#   - age (years)

# RISK FACTORS:
#   - sysbp, diabp (blood pressure)
#   - bmi (body mass index)
#   - totchol (total cholesterol)
#   - glucose
#   - cursmoke (0=No, 1=Yes)
#   - diabetes (0=No, 1=Yes)
#   - cigpday (cigarettes per day)

# OUTCOMES:
#   - anychd (any coronary heart disease)
#   - cvd (cardiovascular disease)
#   - stroke
#   - death

# DERIVED VARIABLES:
#   - age_group (categorical)
#   - bmi_category (Underweight/Normal/Overweight/Obese)
#   - sex_label (Male/Female)
#   - smoking_status (Non-smoker/Current smoker)

# ============================================================================
# TROUBLESHOOTING:
# ============================================================================

# Error: "cannot find file"
#   → Check working directory: getwd()
#   → List files: list.files()
#   → Make sure file name matches exactly

# Error: "object not found"  
#   → Make sure you ran the preparation script first
#   → Check variable names: names(framingham_complete)

# Error: "package not found"
#   → Install it: install.packages("package_name")
#   → Load it: library(package_name)

# ============================================================================
# YOU'RE READY!
# ============================================================================

cat("\n✓ You're all set for your analysis!\n")
cat("✓ Data is clean and ready\n")
cat("✓ All variables are properly coded\n")
cat("✓ Ready to create your R Markdown file!\n\n")
