# Create two vectors
x <- c(1, 2, 3)
y <- c(1.4, 1.7, 4.0)

# Combine as columns
z <- cbind(x, y)
z
#      x   y
# [1,] 1 1.4
# [2,] 2 1.7
# [3,] 3 4.0

# Check dimensions (rows x columns)
dim(z)  # Returns: 3 2