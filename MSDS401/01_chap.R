# setwd(MSDS401)
setwd('/Users/pvishnoi/Downloads/')

# data('/Users/pvishnoi/Downloads/')

getwd()
ls()
rm(list=ls())
save.image()
# save(object, file="mywork.RData")

5+6
x <- 5
y <- 6
z <- x + y
z
ls()
 rm(list = ls())



# ============================================================
# R VECTORS - STEP BY STEP PRACTICE
# Based on "Working with Vectors" Tutorial
# ============================================================

# ============================================================
# PART 1: BASIC ARITHMETIC & OBJECTS
# ============================================================

# Exercise 1.1: Simple Addition
5 + 6

# Exercise 1.2: Create objects and add them
x <- 5
y <- 6
z <- x + y
z


age1 <- 25
age2 <- 30
age3 <- 22
age4 <- 35
age5 <- 28

# With vectors (good way):
ages <- c(25, 30, 22, 35, 28)


scores <- c(85, 92, 78, 95, 88)



5 + 6           # Just adds 5 and 6
x <- 5          # Store 5 in a box called "x"
y <- 6          # Store 6 in a box called "y"
z <- x + y      # Add the boxes


z <- c(1, 2, 3, 1.4, 1.7, 3.1)


x <- c(1, 2, 3)
y <- c(1.4, 1.7, 3.1)
z <- c(x, y)    # Joins them together


x <- 1:11


seq(1, 11, by = 2)
# Creates: 1, 3, 5, 7, 9, 11


seq(1, 11, length = 6)
# Creates: 1, 3, 5, 7, 9, 11

rep(0, 11)
# Creates: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


rep(1:3, 6)
# Creates: 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3


rep(1:3, each = 6)


x <- c(1, 2, 3)
y <- c(10, 20, 30)

x + y
# Result: 11, 22, 33


x <- c(1, 2, 3)
x + 10
# Result: 11, 12, 13


x <- c(1, 2, 3)
y <- c(1.5, 2.5)

x <- append(x, y, after = 1)
# Result: 1, 1.5, 2.5, 2, 3


numbers <- c(4, 9, 16, 25)

sqrt(numbers)
# Result: 2, 3, 4, 5


# Store 6 months of sales data
sales <- c(15000, 18000, 22000, 19000, 21000, 24000)

# Calculate total
sum(sales)      # Total sales: 119000

# Calculate average
mean(sales)     # Average: 19833.33

# Find best month
max(sales)      # Best: 24000



# Store quiz scores
quiz_scores <- c(85, 92, 78, 88, 95, 82, 90)

# How many quizzes?
length(quiz_scores)  # 7 quizzes

# Average score
mean(quiz_scores)    # 87.14

# Highest score
max(quiz_scores)     # 95



# Daily temperatures for a week
temps <- c(72, 75, 68, 70, 73, 76, 74)

# Average temperature
mean(temps)          # 72.57

# Temperature range
max(temps) - min(temps)  # 8 degrees difference