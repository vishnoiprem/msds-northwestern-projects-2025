# ============================================================================
# FIRST TIME SETUP - Complete Guide for Beginners
# ============================================================================
# Run this script BEFORE starting your analysis
# This will set up everything you need
# ============================================================================

cat("\n")
cat("============================================================\n")
cat("  FRAMINGHAM ANALYSIS - FIRST TIME SETUP\n")
cat("============================================================\n\n")

# ============================================================================
# STEP 1: Install Required Packages
# ============================================================================

cat("STEP 1: Installing Required Packages\n")
cat("-------------------------------------\n")
cat("This may take 2-5 minutes...\n\n")

# List of packages
packages <- c("readxl", "dplyr", "tidyr", "ggplot2", 
              "corrplot", "knitr", "rmarkdown", "gridExtra")

# Install function
install_package <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, dependencies = TRUE, quiet = TRUE)
  } else {
    cat(pkg, "already installed ✓\n")
  }
}

# Install all packages
for (pkg in packages) {
  install_package(pkg)
}

cat("\n✓ Package installation complete!\n\n")

# ============================================================================
# STEP 2: Load Libraries
# ============================================================================

cat("STEP 2: Loading Libraries\n")
cat("--------------------------\n")

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(corrplot)
  library(knitr)
})

cat("✓ All libraries loaded successfully!\n\n")

# ============================================================================
# STEP 3: Set Working Directory
# ============================================================================

cat("STEP 3: Set Your Working Directory\n")
cat("-----------------------------------\n")
cat("Current directory:", getwd(), "\n\n")

cat("*** ACTION REQUIRED ***\n")
cat("You need to set your working directory to where your Framingham data is.\n")
cat("Uncomment and modify the line below:\n\n")

# Uncomment and change this path to YOUR folder:
# setwd("C:/Users/YourName/Documents/Framingham")

cat('setwd("C:/Users/YourName/Documents/Framingham")  # <-- CHANGE THIS!\n\n')

cat("After setting the directory, re-run this script.\n\n")

# ============================================================================
# STEP 4: Create Project Folders
# ============================================================================

cat("STEP 4: Creating Project Folders\n")
cat("---------------------------------\n")

# Create folders if they don't exist
folders <- c("data", "scripts", "output", "plots")

for (folder in folders) {
  if (!dir.exists(folder)) {
    dir.create(folder)
    cat("Created folder:", folder, "\n")
  } else {
    cat("Folder exists:", folder, "\n")
  }
}

cat("\n✓ Project structure created!\n\n")

# ============================================================================
# STEP 5: Check for Framingham Data
# ============================================================================

cat("STEP 5: Checking for Framingham Data\n")
cat("-------------------------------------\n")

# List files in current directory
files <- list.files()
cat("Files in current directory:\n")
print(files)

# Check for Framingham data
framingham_files <- grep("framingham|fhs|heart", files, ignore.case = TRUE, value = TRUE)

if (length(framingham_files) > 0) {
  cat("\n✓ Found possible Framingham data file(s):\n")
  print(framingham_files)
} else {
  cat("\n⚠ No Framingham data file found!\n")
  cat("Make sure you've downloaded the data and placed it in this directory.\n")
}

cat("\n")

# ============================================================================
# STEP 6: System Information
# ============================================================================

cat("STEP 6: System Check\n")
cat("--------------------\n")

cat("R Version:", R.version.string, "\n")
cat("Platform:", R.version$platform, "\n")
cat("Operating System:", Sys.info()["sysname"], "\n")
cat("Working Directory:", getwd(), "\n\n")

# ============================================================================
# STEP 7: Test Data Loading (Optional)
# ============================================================================

cat("STEP 7: Test Data Loading\n")
cat("--------------------------\n")
cat("This step will try to load your data if it exists.\n\n")

# Uncomment these lines after you've set your working directory
# and placed the Framingham data in the folder:

# test_file <- "framingham.xlsx"  # Change to your actual filename
# if (file.exists(test_file)) {
#   cat("Testing data load...\n")
#   test_data <- read_excel(test_file)
#   cat("✓ Data loaded successfully!\n")
#   cat("  Rows:", nrow(test_data), "\n")
#   cat("  Columns:", ncol(test_data), "\n")
#   cat("  First few column names:", paste(head(names(test_data)), collapse = ", "), "\n")
#   rm(test_data)  # Clean up
# } else {
#   cat("File not found:", test_file, "\n")
#   cat("Make sure the filename is correct.\n")
# }

cat("\n")

# ============================================================================
# STEP 8: Summary
# ============================================================================

cat("============================================================\n")
cat("  SETUP SUMMARY\n")
cat("============================================================\n\n")

cat("✓ Packages installed and loaded\n")
cat("✓ Project folders created\n")
cat("✓ System check complete\n\n")

cat("NEXT STEPS:\n")
cat("-----------\n")
cat("1. Make sure your Framingham data file is in the working directory\n")
cat("2. Set your working directory using setwd() above\n")
cat("3. Run INSTALL_PACKAGES.R to verify all packages\n")
cat("4. Choose your data preparation method:\n")
cat("   - framingham_data_prep.R (automated)\n")
cat("   - framingham_simplified.R (step-by-step)\n")
cat("5. Use framingham_analysis.Rmd for your analysis\n\n")

cat("If you encounter any errors, check TROUBLESHOOTING.R\n\n")

cat("============================================================\n")
cat("  YOU'RE READY TO START!\n")
cat("============================================================\n\n")

# ============================================================================
# Quick Reference Card
# ============================================================================

cat("\nQUICK REFERENCE CARD\n")
cat("====================\n\n")

cat("Install a package:\n")
cat('  install.packages("package_name")\n\n')

cat("Load a library:\n")
cat('  library(package_name)\n\n')

cat("Set working directory:\n")
cat('  setwd("C:/Your/Path/Here")\n\n')

cat("Check working directory:\n")
cat('  getwd()\n\n')

cat("List files:\n")
cat('  list.files()\n\n')

cat("Load Excel data:\n")
cat('  mydata <- read_excel("filename.xlsx")\n\n')

cat("View first rows:\n")
cat('  head(mydata)\n\n')

cat("See structure:\n")
cat('  str(mydata)\n\n')

cat("Get help:\n")
cat('  ?function_name\n')
cat('  help(package_name)\n\n')

cat("Save this card for quick reference!\n\n")

# ============================================================================
# End of Setup Script
# ============================================================================

cat("\nSetup script complete!\n")
cat("If everything looks good, you can proceed with your analysis.\n\n")
