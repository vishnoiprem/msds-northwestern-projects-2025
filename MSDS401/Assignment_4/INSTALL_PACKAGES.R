# ============================================================================
# INSTALL REQUIRED PACKAGES - RUN THIS FIRST!
# ============================================================================
# This script installs all packages needed for the Framingham analysis
# You only need to run this ONCE
# ============================================================================

cat("Installing required packages for Framingham Heart Study analysis...\n\n")

# List of required packages
required_packages <- c(
  "readxl",      # For reading Excel files
  "dplyr",       # For data manipulation
  "tidyr",       # For data tidying
  "ggplot2",     # For beautiful visualizations
  "corrplot",    # For correlation plots
  "knitr",       # For creating reports
  "rmarkdown",   # For R Markdown documents
  "gridExtra"    # For arranging multiple plots
)

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat("Installing:", package, "...\n")
    install.packages(package, dependencies = TRUE)
    cat("✓", package, "installed successfully!\n\n")
  } else {
    cat("✓", package, "is already installed\n")
  }
}

# Install all required packages
cat("Checking and installing packages...\n")
cat("=====================================\n\n")

for (pkg in required_packages) {
  install_if_missing(pkg)
}

cat("\n=====================================\n")
cat("Installation complete!\n\n")

# Verify installations
cat("Verifying installations...\n")
cat("=====================================\n")

all_installed <- TRUE
for (pkg in required_packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("✓", pkg, "- OK\n")
  } else {
    cat("✗", pkg, "- FAILED\n")
    all_installed <- FALSE
  }
}

cat("=====================================\n\n")

if (all_installed) {
  cat("🎉 SUCCESS! All packages installed correctly.\n")
  cat("You're ready to start your analysis!\n\n")
  cat("Next steps:\n")
  cat("1. Run framingham_simplified.R or framingham_data_prep.R\n")
  cat("2. Then use framingham_analysis.Rmd for your analysis\n")
} else {
  cat("⚠️ Some packages failed to install.\n")
  cat("Please try installing them individually:\n")
  cat("install.packages('package_name')\n")
}

# ============================================================================
# Optional: Load all packages to test
# ============================================================================
cat("\nTesting package loading...\n")
cat("=====================================\n")

test_load <- function(package) {
  tryCatch({
    library(package, character.only = TRUE)
    cat("✓", package, "loaded successfully\n")
    TRUE
  }, error = function(e) {
    cat("✗", package, "failed to load:", e$message, "\n")
    FALSE
  })
}

for (pkg in required_packages) {
  test_load(pkg)
}

cat("=====================================\n")
cat("\nPackage installation script complete!\n")
