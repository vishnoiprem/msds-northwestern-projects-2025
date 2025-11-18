# ============================================================================
# SIMPLIFIED FRAMINGHAM DATA PREPARATION GUIDE
# ============================================================================
# Follow these steps one at a time for your Assignment 4
# ============================================================================

# STEP 1: Setup
# ============================================================================
# Install packages if needed (run once):
# install.packages(c("readxl", "dplyr", "ggplot2", "corrplot"))

# Load libraries
library(readxl)
library(dplyr)

# Set your working directory (change this path!)
setwd("C:/Your/Path/Here")  # Change to where your Framingham data is saved

# ============================================================================
# STEP 2: Load Data
# ============================================================================
# Load the Framingham data (change filename if needed)
mydata <- read_excel("framingham.xlsx")

# Check what you loaded
dim(mydata)        # Shows rows and columns
names(mydata)      # Shows variable names
head(mydata)       # Shows first few rows

# ============================================================================
# STEP 3: Remove Time 2 and 3 Variables
# ============================================================================
# Keep only variables that DON'T end in 2 or 3
# And DON'T start with TIME

# Method 1: Using column selection
cols_to_keep <- !grepl("[23]$", names(mydata)) & 
                !grepl("^TIME", names(mydata), ignore.case = TRUE)
mydata <- mydata[, cols_to_keep]

# Check the result
cat("Dataset now has", ncol(mydata), "columns\n")

# ============================================================================
# STEP 4: Remove Missing Values
# ============================================================================
# Check how many complete cases you have
cat("Complete cases:", sum(complete.cases(mydata)), 
    "out of", nrow(mydata), "\n")

# Remove rows with any missing data
mydata <- mydata[complete.cases(mydata), ]

cat("After removing missing values:", nrow(mydata), "rows\n")

# ============================================================================
# STEP 5: Recode Yes/No Variables
# ============================================================================
# Find which columns have Yes/No data
char_columns <- names(mydata)[sapply(mydata, is.character)]
cat("Character columns:", paste(char_columns, collapse = ", "), "\n")

# Example: Recode DEATH variable (adjust for your actual variable names)
# Check unique values first
if("DEATH" %in% names(mydata)) {
  table(mydata$DEATH)  # See what values exist
  
  # Create binary version
  mydata$d_death <- ifelse(mydata$DEATH == 'Yes', 1, 
                           ifelse(mydata$DEATH == 'No', 0, 99))
  
  # Check the recoding
  table(mydata$DEATH, mydata$d_death)
}

# REPEAT FOR OTHER YES/NO VARIABLES
# Examples (adjust based on your actual columns):

# If you have ANYCHD:
if("ANYCHD" %in% names(mydata)) {
  mydata$d_anychd <- ifelse(mydata$ANYCHD == 'Yes', 1,
                            ifelse(mydata$ANYCHD == 'No', 0, 99))
}

# If you have STROKE:
if("STROKE" %in% names(mydata)) {
  mydata$d_stroke <- ifelse(mydata$STROKE == 'Yes', 1,
                            ifelse(mydata$STROKE == 'No', 0, 99))
}

# If you have CVD:
if("CVD" %in% names(mydata)) {
  mydata$d_cvd <- ifelse(mydata$CVD == 'Yes', 1,
                         ifelse(mydata$CVD == 'No', 0, 99))
}

# If you have HYPERTEN:
if("HYPERTEN" %in% names(mydata)) {
  mydata$d_hyperten <- ifelse(mydata$HYPERTEN == 'Yes', 1,
                               ifelse(mydata$HYPERTEN == 'No', 0, 99))
}

# ============================================================================
# STEP 6: Save Your Clean Dataset
# ============================================================================
# Save as RDS (R format - best for later use)
saveRDS(mydata, "FHS_assign4.rds")

# Save as CSV (can open in Excel)
write.csv(mydata, "FHS_assign4.csv", row.names = FALSE)

cat("\nData saved!\n")

# ============================================================================
# STEP 7: Basic Exploratory Data Analysis
# ============================================================================

# Summary statistics
summary(mydata)

# Structure
str(mydata)

# View first few rows
head(mydata)

# ============================================================================
# STEP 8: Ready for Analysis!
# ============================================================================
# To reload your data later, use:
# mydata <- readRDS("FHS_assign4.rds")

cat("\nData preparation complete! You're ready for analysis.\n")
