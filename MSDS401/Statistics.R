scores <- c(65, 75, 85, 90, 95)
summary(scores)

x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)

summary(x)


x <- c(10, 5, 20, 15, 8)

min(x)         # Returns VALUE: 5
which.min(x)   # Returns POSITION: 2 (5 is at position 2)

max(x)         # Returns VALUE: 20
which.max(x)   # Returns POSITION: 3 (20 is at position 3)


mean(x)


x <- c(10, 20, 30, 40, 50)

x[1]    # First element = 10
x[3]    # Third element = 30
x[5]    # Fifth (last) element = 50


x <- c(10, 20, 30, 40, 50, 60, 70, 80)


weights <- c(8.75, 9.45, 9.35, 9.85, 9.45, 10.55,    # Litter 1
             9.75, 8.25, 10.55, 9.45, 9.75, 8.45)    # Litter 2


x <- c(10, 20, 30, 40, 50)



scores <- c(65, 75, 85, 90, 95)

# Which scores are above 80?
scores[scores > 80]
# Result: 85, 90, 95

# Where are scores above 80?
which(scores > 80)
# Result: 3, 4, 5 (positions)

# How many scores above 80?
sum(scores > 80)
# Result: 3 (count)