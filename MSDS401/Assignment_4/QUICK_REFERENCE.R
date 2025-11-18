# ============================================================================
# FRAMINGHAM HEART STUDY - QUICK REFERENCE GUIDE
# ============================================================================

## FILES CREATED FOR YOU:
## 1. framingham_data_prep.R - Complete automated data preparation
## 2. framingham_simplified.R - Step-by-step manual preparation  
## 3. framingham_analysis.Rmd - Full analysis template
## 4. This file - Quick reference guide

# ============================================================================
# WORKFLOW OVERVIEW
# ============================================================================

# STEP 1: Download Data
#   - Download Framingham data (Excel file)
#   - Download Data Dictionary (PDF)
#   - Save both to a folder on your computer

# STEP 2: Data Preparation (Choose ONE method)
#   METHOD A: Use framingham_data_prep.R (automated)
#   METHOD B: Use framingham_simplified.R (step-by-step)
#   METHOD C: Do it manually in Excel then import to R

# STEP 3: Analysis
#   - Use framingham_analysis.Rmd template
#   - Customize for your specific questions
#   - Knit to HTML for submission

# ============================================================================
# QUICK START - RECOMMENDED WORKFLOW
# ============================================================================

# 1. Set working directory
setwd("C:/Your/Path/To/Framingham/Data")

# 2. Run the simplified prep script
source("framingham_simplified.R")

# 3. Your data is now ready as 'mydata'
# 4. Open framingham_analysis.Rmd in RStudio
# 5. Knit to HTML

# ============================================================================
# KEY VARIABLES IN FRAMINGHAM DATA (Time Point 1)
# ============================================================================

# DEMOGRAPHIC:
#   - SEX1: Sex (1=Male, 2=Female)
#   - AGE1: Age in years

# PHYSICAL MEASUREMENTS:
#   - SYSBP1: Systolic blood pressure (mmHg)
#   - DIABP1: Diastolic blood pressure (mmHg)  
#   - BMI1: Body Mass Index (kg/m²)
#   - HEARTRTE1: Heart rate (bpm)

# LAB VALUES:
#   - TOTCHOL1: Total cholesterol (mg/dL)
#   - GLUCOSE1: Glucose level (mg/dL)

# BEHAVIORAL:
#   - CURSMOKE1: Current smoker (Yes/No)
#   - CIGPDAY1: Cigarettes per day

# OUTCOMES (typically Yes/No):
#   - ANYCHD: Any coronary heart disease
#   - STROKE: Stroke event
#   - CVD: Cardiovascular disease
#   - HYPERTEN: Hypertension
#   - DIABETES: Diabetes
#   - DEATH: Death event

# ============================================================================
# COMMON DATA RECODING TASKS
# ============================================================================

# Recode Yes/No to 1/0 (example for DEATH variable):
mydata$d_death <- ifelse(mydata$DEATH == 'Yes', 1,
                         ifelse(mydata$DEATH == 'No', 0, 99))

# Create age groups:
mydata$age_group <- cut(mydata$AGE1,
                        breaks = c(0, 40, 50, 60, 70, 100),
                        labels = c("<40", "40-50", "50-60", "60-70", "70+"))

# Create BMI categories:
mydata$bmi_cat <- cut(mydata$BMI1,
                      breaks = c(0, 18.5, 25, 30, 100),
                      labels = c("Underweight", "Normal", "Overweight", "Obese"))

# Create BP categories:
mydata$bp_cat <- cut(mydata$SYSBP1,
                     breaks = c(0, 120, 140, 160, 300),
                     labels = c("Normal", "Elevated", "Stage1", "Stage2"))

# ============================================================================
# COMMON ANALYSES FOR THIS ASSIGNMENT
# ============================================================================

# 1. DESCRIPTIVE STATISTICS
summary(mydata)
table(mydata$SEX1)
mean(mydata$AGE1)
sd(mydata$SYSBP1)

# 2. CROSS-TABULATIONS
table(mydata$SEX1, mydata$d_anychd)
prop.table(table(mydata$SEX1, mydata$d_anychd))

# 3. CORRELATION
cor(mydata$AGE1, mydata$SYSBP1, use = "complete.obs")
cor(mydata[, c("AGE1", "SYSBP1", "BMI1")], use = "complete.obs")

# 4. T-TESTS
t.test(SYSBP1 ~ SEX1, data = mydata)
t.test(AGE1 ~ d_cvd, data = mydata)

# 5. CHI-SQUARE TESTS
chisq.test(table(mydata$SEX1, mydata$d_hyperten))

# 6. SIMPLE LINEAR REGRESSION
model1 <- lm(SYSBP1 ~ AGE1, data = mydata)
summary(model1)

# 7. MULTIPLE REGRESSION
model2 <- lm(SYSBP1 ~ AGE1 + BMI1 + SEX1, data = mydata)
summary(model2)

# 8. LOGISTIC REGRESSION (for binary outcomes)
logit1 <- glm(d_cvd ~ AGE1 + SYSBP1, data = mydata, family = binomial)
summary(logit1)
exp(coef(logit1))  # Odds ratios

# ============================================================================
# COMMON VISUALIZATIONS
# ============================================================================

# Histogram
hist(mydata$AGE1, main = "Age Distribution", xlab = "Age")

# Boxplot
boxplot(SYSBP1 ~ SEX1, data = mydata, 
        main = "SBP by Sex", xlab = "Sex", ylab = "SBP")

# Scatterplot
plot(mydata$AGE1, mydata$SYSBP1,
     main = "SBP vs Age", xlab = "Age", ylab = "SBP")
abline(lm(SYSBP1 ~ AGE1, data = mydata), col = "red")

# Using ggplot2 (prettier!)
library(ggplot2)

ggplot(mydata, aes(x = AGE1)) +
  geom_histogram(bins = 30, fill = "steelblue") +
  theme_minimal()

ggplot(mydata, aes(x = factor(SEX1), y = SYSBP1)) +
  geom_boxplot(fill = "coral") +
  theme_minimal()

ggplot(mydata, aes(x = AGE1, y = SYSBP1)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  theme_minimal()

# ============================================================================
# TROUBLESHOOTING COMMON ERRORS
# ============================================================================

# ERROR: "Object not found"
# SOLUTION: Make sure you've loaded your data first
mydata <- readRDS("FHS_assign4.rds")

# ERROR: "could not find function"
# SOLUTION: Load the required library
library(dplyr)  # or whatever package you need

# ERROR: "NA/NaN/Inf in foreign function call"
# SOLUTION: Remove missing values
mydata_clean <- na.omit(mydata)

# ERROR: Variable names not found
# SOLUTION: Check exact variable names
names(mydata)

# ERROR: Can't knit Rmd file
# SOLUTION: Make sure all code chunks run without errors
# Click "Run All" before knitting

# ============================================================================
# CHECKLIST BEFORE SUBMISSION
# ============================================================================

# Data Preparation:
# [ ] Downloaded Framingham data
# [ ] Removed time point 2 and 3 variables
# [ ] Removed TIME variables
# [ ] Removed rows with missing values
# [ ] Recoded Yes/No variables to 1/0
# [ ] Saved clean dataset

# Analysis:
# [ ] Loaded clean data into R
# [ ] Performed descriptive statistics
# [ ] Created visualizations
# [ ] Conducted appropriate statistical tests
# [ ] Interpreted results correctly
# [ ] Documented all steps

# R Markdown:
# [ ] All code chunks run without errors
# [ ] Document knits to HTML successfully
# [ ] Included explanatory text
# [ ] Graphs are clearly labeled
# [ ] Results are interpreted

# Submission:
# [ ] .Rmd file (your code)
# [ ] .html file (knitted output)
# [ ] Both files named appropriately

# ============================================================================
# ADDITIONAL RESOURCES
# ============================================================================

# R Documentation:
?lm        # Linear models
?glm       # Generalized linear models
?cor       # Correlation
?t.test    # T-test
?chisq.test # Chi-square test

# Getting Help:
help(package = "dplyr")
?ggplot2

# RStudio Cheatsheets (very helpful!):
# https://www.rstudio.com/resources/cheatsheets/

# ============================================================================
cat("\nQuick Reference Guide Loaded!\n")
cat("Use this as a companion to your analysis.\n")
cat("Good luck with your assignment!\n")
# ============================================================================
