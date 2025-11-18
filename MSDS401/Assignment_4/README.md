# FRAMINGHAM HEART STUDY DATA ANALYSIS - ASSIGNMENT 4
## Complete Guide and Resources

---

##  TABLE OF CONTENTS
1. [Overview](#overview)
2. [Files Provided](#files-provided)
3. [Getting Started](#getting-started)
4. [Step-by-Step Instructions](#step-by-step-instructions)
5. [Common Issues and Solutions](#common-issues-and-solutions)
6. [Tips for Success](#tips-for-success)

---

##  OVERVIEW

This assignment involves analyzing data from the **Framingham Heart Study**, one of the most important epidemiological studies in cardiovascular disease research. You will:

1. Clean and prepare the dataset
2. Perform exploratory data analysis (EDA)
3. Conduct statistical analyses
4. Create visualizations
5. Interpret results

**Total Points: 75**

---

##  FILES PROVIDED

I've created 4 comprehensive files to help you:

### 1. **framingham_data_prep.R**
   - **Purpose**: Complete automated data cleaning
   - **Use When**: You want everything done automatically
   - **Features**:
     - Removes time point 2 and 3 variables
     - Handles missing values
     - Recodes Yes/No to 1/0
     - Creates visualizations
     - Performs correlation analysis
     - Saves clean dataset

### 2. **framingham_simplified.R**
   - **Purpose**: Step-by-step manual preparation
   - **Use When**: You want to understand each step
   - **Features**:
     - Clear comments for each step
     - Easy to customize
     - Good for learning
     - Includes examples for common variables

### 3. **framingham_analysis.Rmd**
   - **Purpose**: Complete analysis template
   - **Use When**: Ready to do your actual analysis
   - **Features**:
     - 10 sections matching rubric
     - Pre-built visualizations
     - Statistical tests included
     - Professional HTML output
     - Ready to customize

### 4. **QUICK_REFERENCE.R**
   - **Purpose**: Quick lookup guide
   - **Use When**: You need a reminder on syntax
   - **Features**:
     - Common commands
     - Variable names
     - Troubleshooting tips
     - Checklist before submission

---

##  GETTING STARTED

### Prerequisites

1. **Install R** (version 4.0 or higher)
   - Download from: https://cran.r-project.org/

2. **Install RStudio** (recommended)
   - Download from: https://www.rstudio.com/

3. **Install Required Packages**
   ```r
   install.packages(c("readxl", "dplyr", "ggplot2", "tidyr", 
                      "corrplot", "knitr", "gridExtra"))
   ```

### Download Data

1. Download the **Framingham Heart Study Data** (Excel format)
2. Download the **Data Dictionary** (PDF)
3. Save both to a dedicated folder (e.g., `C:/MyDocuments/Framingham/`)

---

##  STEP-BY-STEP INSTRUCTIONS

### Method A: Automated (Fastest)

```r
# 1. Set working directory
setwd("C:/Your/Path/To/Framingham")

# 2. Place framingham.xlsx in this folder

# 3. Run the automated script
source("framingham_data_prep.R")

# 4. Your clean data is ready! Continue with analysis.
```

### Method B: Step-by-Step (Best for Learning)

```r
# 1. Set working directory
setwd("C:/Your/Path/To/Framingham")

# 2. Open framingham_simplified.R in RStudio

# 3. Run each section one at a time
#    - Read the comments
#    - Understand what each line does
#    - Check the output after each step

# 4. Modify variable names as needed for your data

# 5. Save your clean dataset
```

### Method C: Excel First (Easiest for Beginners)

1. **Open Framingham data in Excel**
   
2. **Remove unwanted columns:**
   - Delete all columns ending in '2' (e.g., AGE2, SEX2)
   - Delete all columns ending in '3' (e.g., AGE3, SEX3)
   - Delete all columns starting with 'TIME' (e.g., TIMEAP, TIMEMI)

3. **Check for missing values:**
   - Use Excel's filter feature
   - Delete rows with blanks
   - Save as `FHS_cleaned.xlsx`

4. **Recode Yes/No variables:**
   - Sort by each Yes/No column
   - Replace all "Yes" with 1
   - Replace all "No" with 0
   - Save your work

5. **Import to R:**
   ```r
   library(readxl)
   mydata <- read_excel("FHS_cleaned.xlsx")
   saveRDS(mydata, "FHS_assign4.rds")
   ```

---

##  ANALYSIS WORKFLOW

### Once Your Data is Clean:

1. **Open RStudio**

2. **Create New Project** (File → New Project)

3. **Open the Analysis Template**
   - File → Open File → `framingham_analysis.Rmd`

4. **Customize Each Section**
   - Section 1: Data Overview (5 pts)
   - Section 2: Descriptive Statistics (10 pts)
   - Section 3: Visualization (10 pts)
   - Section 4-10: Your specific analyses (50 pts)

5. **Knit to HTML**
   - Click the "Knit" button at the top
   - Fix any errors that appear
   - Re-knit until successful

6. **Review Output**
   - Check all graphs display correctly
   - Verify statistics are meaningful
   - Proofread interpretations

---

## ️ COMMON ISSUES AND SOLUTIONS

### Issue 1: "Cannot find file"
**Solution:**
```r
# Check your working directory
getwd()

# Set it to where your files are
setwd("C:/Correct/Path/Here")

# List files to verify
list.files()
```

### Issue 2: "Object 'mydata' not found"
**Solution:**
```r
# Load your data first
mydata <- readRDS("FHS_assign4.rds")
# OR
mydata <- read_excel("framingham.xlsx")
```

### Issue 3: "Package not installed"
**Solution:**
```r
# Install the missing package
install.packages("package_name")

# Then load it
library(package_name)
```

### Issue 4: "Column not found"
**Solution:**
```r
# Check exact column names
names(mydata)

# Use exact names from output
# Remember R is case-sensitive!
```

### Issue 5: "Cannot knit Rmd file"
**Solution:**
1. Run all code chunks individually first
2. Fix any errors before knitting
3. Make sure all files are in the working directory
4. Check that all libraries are loaded

### Issue 6: "Missing values in analysis"
**Solution:**
```r
# Remove NAs for specific analysis
cor(mydata$AGE1, mydata$SYSBP1, use = "complete.obs")

# Or create clean subset
mydata_complete <- na.omit(mydata)
```

---

## 💡 TIPS FOR SUCCESS

### Data Preparation
-  **Keep your original data file** - never overwrite it
-  **Document every change** you make
-  **Save intermediate versions** as you work
-  **Check data after each major step**

### Analysis
-  **Start simple** - basic statistics first
-  **Visualize before testing** - graphs reveal patterns
-  **Check assumptions** - especially for regression
-  **Interpret thoughtfully** - statistical ≠ practical significance

### R Markdown
-  **Use descriptive chunk names**: `{r load-data}` not `{r}`
-  **Add text between chunks** - explain your thinking
-  **Set chunk options**: 
  ```r
  {r, echo=TRUE, warning=FALSE, message=FALSE}
  ```
-  **Test frequently** - don't wait until the end to knit

### Writing
-  **Be concise but complete**
-  **Explain statistical terms** (e.g., "p < 0.05 indicates...")
-  **Reference specific numbers** from your output
-  **Connect findings to health implications**

---

## 📈 SUGGESTED ANALYSES

Based on typical Framingham data:

### Descriptive (Sections 1-3)
1. Age distribution
2. Sex distribution  
3. Mean/SD of clinical variables
4. Frequency of outcomes (CVD, stroke, death)

### Bivariate (Sections 4-6)
1. Age vs. Blood Pressure
2. BMI vs. CVD outcomes
3. Sex differences in risk factors
4. Smoking and heart disease

### Multivariable (Sections 7-10)
1. Multiple regression: Predict SBP from age, BMI, sex
2. Logistic regression: Predict CVD from risk factors
3. Model comparison
4. Risk factor importance

---

##  PRE-SUBMISSION CHECKLIST

### Code Quality
- [ ] All code runs without errors
- [ ] No hard-coded file paths (use relative paths)
- [ ] Libraries loaded at the beginning
- [ ] Comments explain complex code

### Analysis Quality  
- [ ] Appropriate statistics for data types
- [ ] Assumptions checked
- [ ] Results interpreted correctly
- [ ] Graphs have titles and labels

### Document Quality
- [ ] .Rmd file is well-organized
- [ ] Text explains each analysis
- [ ] HTML knits successfully
- [ ] Professional appearance

### Submission
- [ ] Both .Rmd and .html files
- [ ] Files named appropriately
- [ ] Submitted before deadline

---

##  GETTING HELP

### Within R:
```r
# Help on a function
?lm
help(ggplot)

# Examples
example(lm)

# Search for topic
help.search("regression")
```

### Online Resources:
- **R Documentation**: https://www.rdocumentation.org/
- **Stack Overflow**: https://stackoverflow.com/questions/tagged/r
- **RStudio Cheatsheets**: https://www.rstudio.com/resources/cheatsheets/
- **Quick-R**: https://www.statmethods.net/

### Your Instructor:
- Office hours
- Email
- Discussion board

---

##  FINAL NOTES

**Time Management:**
- Data preparation: 2-3 hours
- Analysis and visualization: 3-4 hours  
- Writing and interpretation: 2-3 hours
- **Total: 7-10 hours** (don't wait until last minute!)

**Grading Focus:**
- Correct statistical methods (40%)
- Proper interpretation (30%)
- Clear presentation (20%)
- Code quality (10%)

**Remember:**
- This is about learning, not perfection
- Start early and ask questions
- Focus on understanding, not just getting answers
- Document your process

---

