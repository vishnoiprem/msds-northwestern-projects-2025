# ============================================================================
# TROUBLESHOOTING GUIDE - Common Errors and Solutions
# ============================================================================

# ERROR 1: "there is no package called 'readxl'" (or any package name)
# ============================================================================
# SOLUTION: Install the missing package

# Option A: Install single package
install.packages("readxl")

# Option B: Install all required packages at once (RECOMMENDED)
install.packages(c("readxl", "dplyr", "tidyr", "ggplot2", 
                   "corrplot", "knitr", "rmarkdown", "gridExtra"))

# Option C: Run the installation script
source("INSTALL_PACKAGES.R")

# Then try loading the library again:
library(readxl)


# ERROR 2: "cannot open file 'framingham.xlsx': No such file or directory"
# ============================================================================
# SOLUTION: Set your working directory correctly

# Check where R is currently looking
getwd()

# Set it to where your Framingham data file is located
setwd("C:/Users/YourName/Documents/Framingham")  # Change this path!

# Or use RStudio: Session → Set Working Directory → Choose Directory

# Verify the file is there
list.files()  # Should show framingham.xlsx in the list


# ERROR 3: "object 'mydata' not found"
# ============================================================================
# SOLUTION: Load your data first

# Make sure you've loaded the data
mydata <- readRDS("FHS_assign4.rds")
# OR
mydata <- read_excel("framingham.xlsx")

# Check if it loaded
head(mydata)
dim(mydata)


# ERROR 4: "Error in names(mydata) : object 'mydata' not found"
# ============================================================================
# SOLUTION: Same as Error 3 - load your data first


# ERROR 5: "could not find function 'read_excel'"
# ============================================================================
# SOLUTION: Load the readxl library

library(readxl)

# If this gives an error, install the package first
install.packages("readxl")
library(readxl)


# ERROR 6: "subscript out of bounds" or "undefined columns selected"
# ============================================================================
# SOLUTION: Check your column names

# See all column names
names(mydata)

# Use exact names (R is case-sensitive!)
# Wrong: mydata$age1
# Right: mydata$AGE1


# ERROR 7: "Error in file(file, "rt") : cannot open the connection"
# ============================================================================
# SOLUTION: File path is wrong

# Check your working directory
getwd()

# Set it correctly
setwd("C:/Your/Correct/Path")

# Or use full file path
mydata <- read_excel("C:/Full/Path/To/framingham.xlsx")


# ERROR 8: "non-numeric argument to binary operator"
# ============================================================================
# SOLUTION: Check variable types

# See what type a variable is
class(mydata$AGE1)

# If it should be numeric but isn't, convert it
mydata$AGE1 <- as.numeric(mydata$AGE1)


# ERROR 9: "Error in xy.coords(x, y, xlabel, ylabel, log) : 'x' and 'y' lengths differ"
# ============================================================================
# SOLUTION: Your variables have different lengths (usually due to NAs)

# Remove NA values
mydata_clean <- na.omit(mydata)

# Or use complete.obs in correlation
cor(mydata$AGE1, mydata$SYSBP1, use = "complete.obs")


# ERROR 10: "package 'XXX' is not available for this version of R"
# ============================================================================
# SOLUTION: Update R or try CRAN mirror

# Try different CRAN mirror
install.packages("package_name", repos = "https://cloud.r-project.org")

# Check R version
R.version.string

# Update R if needed (download from: https://cran.r-project.org/)


# ERROR 11: "Error in loadNamespace(name) : there is no package called 'XXX'"
# ============================================================================
# SOLUTION: Install dependencies

install.packages("package_name", dependencies = TRUE)


# ERROR 12: RStudio won't knit the Rmd file
# ============================================================================
# SOLUTION: Several possible fixes

# 1. Make sure rmarkdown is installed
install.packages("rmarkdown")

# 2. Run all code chunks first to find errors
# Click "Run All" button

# 3. Clear workspace and try again
rm(list = ls())

# 4. Restart R session
# Session → Restart R

# 5. Check that file path doesn't have spaces or special characters


# ERROR 13: "Error in file.exists(file) : invalid 'file' argument"
# ============================================================================
# SOLUTION: Provide correct file path

# Wrong: file with spaces and no quotes
# Right: 
mydata <- read_excel("Framingham Data.xlsx")  # With quotes!


# ERROR 14: "Warning: package 'XXX' was built under R version X.X.X"
# ============================================================================
# SOLUTION: This is just a warning, usually safe to ignore
# But you can update the package:

update.packages()


# ERROR 15: "Error in cor(...) : missing observations in cov/cor"
# ============================================================================
# SOLUTION: Add use = "complete.obs"

cor(mydata$AGE1, mydata$SYSBP1, use = "complete.obs")

# Or remove NAs first
mydata_clean <- na.omit(mydata)
cor(mydata_clean$AGE1, mydata_clean$SYSBP1)


# ============================================================================
# INSTALLATION ISSUES ON DIFFERENT SYSTEMS
# ============================================================================

# WINDOWS:
# If packages won't install, try:
# 1. Run RStudio as Administrator
# 2. Check if antivirus is blocking
# 3. Use: install.packages("package", type = "binary")

# MAC:
# If you get compiler errors:
# 1. Install Xcode Command Line Tools
# 2. Open Terminal and run: xcode-select --install
# 3. Try installing again

# LINUX:
# If you get dependency errors:
# 1. Install system libraries first
# 2. For Ubuntu/Debian:
#    sudo apt-get install libxml2-dev libcurl4-openssl-dev libssl-dev


# ============================================================================
# QUICK DIAGNOSTIC SCRIPT
# ============================================================================

cat("\n=== DIAGNOSTIC CHECK ===\n\n")

# Check R version
cat("R Version:", R.version.string, "\n\n")

# Check working directory
cat("Working Directory:", getwd(), "\n\n")

# List files in directory
cat("Files in current directory:\n")
print(list.files())

cat("\n")

# Check if packages are installed
packages_to_check <- c("readxl", "dplyr", "ggplot2", "corrplot")
cat("Package Status:\n")
for (pkg in packages_to_check) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("✓", pkg, "- Installed\n")
  } else {
    cat("✗", pkg, "- NOT installed\n")
  }
}

cat("\n=== END DIAGNOSTIC ===\n")


# ============================================================================
# STILL HAVING ISSUES?
# ============================================================================

# Try this complete reset:

# 1. Close RStudio completely
# 2. Open RStudio fresh
# 3. Run this:

# Clear everything
rm(list = ls())

# Set working directory
setwd("C:/Your/Path/Here")  # CHANGE THIS!

# Install packages
install.packages(c("readxl", "dplyr", "ggplot2"), dependencies = TRUE)

# Load libraries
library(readxl)
library(dplyr)
library(ggplot2)

# Try loading data
mydata <- read_excel("framingham.xlsx")

# If you get here without errors, you're good to go!
cat("\n✓ Everything is working!\n")


# ============================================================================
# CONTACT HELP
# ============================================================================

# If nothing works:
# 1. Note the EXACT error message
# 2. Note what command you ran
# 3. Check R version: R.version.string
# 4. Ask your instructor or classmate

cat("\nRemember: Every error message is helpful - it tells you what's wrong!\n")
