# Create example data
set.seed(123)  # for reproducibility

Brand <- rep(c("A", "B", "C"), each = 10)

Cheese <- c(
  rnorm(10, mean = 42, sd = 4),  # Brand A
  rnorm(10, mean = 39, sd = 3.5), # Brand B
  rnorm(10, mean = 47, sd = 4.5)  # Brand C
)

df <- data.frame(Brand, Cheese)

# View first few rows
head(df)