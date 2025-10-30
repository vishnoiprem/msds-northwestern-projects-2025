



# Section 1: Vector Manipulations
# r# (1)(a)
vec <- c(seq(0, 4), 13, rep(c(2, -5.1, -23), 3), 7/42 + 3 + 35/42)


vec


# (1)(b)
sorted_vec <- sort(vec)
sorted_vec
L <- length(sorted_vec)
L
descending_seq <- seq(L, 1)
result_vec <- sorted_vec + descending_seq
result_vec


# (1)(c)
first_last <- c(result_vec[1], result_vec[L])
first_last
middle_elements <- result_vec[2:(L-1)]
middle_elements


# (1)(d)
reconstructed <- c(first_last[1], middle_elements, first_last[2])
reconstructed
sum(reconstructed)



# Section 2: Trigonometric Function


# (2)(a)
trig_function <- function(x) {
  y <- sin(x/2) + cos(x/2)
  return(y)
}


# (2)(b)
x <- seq(-2, 2, length.out = 4001)
y <- trig_function(x)
max_y <- round(max(y), 3)
x_at_max <- round(x[which.max(y)], 3)
max_y
x_at_max


plot(x, y, type = "l", col = "blue",
     main = "Trigonometric Function y = sin(x/2) + cos(x/2)",
     xlab = "x", ylab = "y", lwd = 2)
points(x_at_max, max_y, col = "red", pch = 19, cex = 1.5)
text(x_at_max, max_y,
     labels = paste("Max: (", x_at_max, ", ", max_y, ")", sep = ""),
     pos = 3, col = "red")



#Section 3: Intersection of Functions


# Section 3
x <- seq(-2, 2, length.out = 4001)
y1 <- cos(x/2) * sin(x/2)
y2 <- -(x/2)^3

# Find intersection point
diff <- abs(y1 - y2)
intersection_idx <- which.min(diff)
x_intersect <- round(x[intersection_idx], 3)
y_intersect <- round(y1[intersection_idx], 3)

# Plot
plot(x, y1, type = "l", col = "blue", lwd = 2,
     main = "Intersection of Two Functions",
     xlab = "x", ylab = "y", ylim = range(c(y1, y2)))
lines(x, y2, col = "red", lwd = 2)
points(x_intersect, y_intersect, col = "darkgreen", pch = 19, cex = 1.5)
text(x_intersect, y_intersect,
     labels = paste("(", x_intersect, ", ", y_intersect, ")", sep = ""),
     pos = 4, col = "darkgreen")
legend("topright", legend = c("cos(x/2)*sin(x/2)", "-(x/2)^3"),
       col = c("blue", "red"), lwd = 2)


#Section 4: Trees Dataset


# (4)(a)
data(trees)
str(trees)
medians <- apply(trees, 2, median)
medians
trees[trees$Girth == medians["Girth"], ]


# (4)(b)
# (4)(b)
radius <- trees$Girth / 2
area <- pi * radius^2

stem(radius)
hist(radius, col = "lightblue", main = "Histogram of Tree Radii",
     xlab = "Radius (inches)", breaks = 10)
plot(radius, area, col = "darkgreen", pch = 19,
     main = "Cross-sectional Area vs Radius",
     xlab = "Radius (inches)", ylab = "Area (square inches)")



# (4)(c)
boxplot(area, horizontal = TRUE, notch = TRUE, col = "coral",
        main = "Boxplot of Tree Cross-sectional Areas",
        xlab = "Area (square inches)")


# (4)(d)
stats <- boxplot.stats(area)
Q1 <- quantile(area, 0.25)
Q3 <- quantile(area, 0.75)
IQR_val <- IQR(area)
extreme_lower <- Q1 - 3 * IQR_val
extreme_upper <- Q3 + 3 * IQR_val
max(area) <= extreme_upper  # Should be TRUE (not extreme outlier)

max_area_idx <- which.max(area)
trees[max_area_idx, ]




#Section 5: Exponential vs Normal Distribution


# (5)(a)
set.seed(124)
y <- rexp(100, rate = 5.5)
set.seed(127)
x <- rnorm(100, mean = 0, sd = 0.15)

combined <- cbind(x, y)
iqr_values <- apply(combined, 2, IQR)
round(iqr_values, 4)


# (5)(b)
par(mfrow = c(2, 2))
hist(x, col = "lightblue", main = "Histogram of x (Normal)",
     xlab = "x")
boxplot(x, horizontal = TRUE, col = "lightblue",
        main = "Boxplot of x (Normal)")
hist(y, col = "salmon", main = "Histogram of y (Exponential)",
     xlab = "y")
boxplot(y, horizontal = TRUE, col = "salmon",
        main = "Boxplot of y (Exponential)")

# (5)(c)
par(mfrow = c(1, 2))
qqnorm(x, col = "blue", main = "Normal Q-Q Plot for x")
qqline(x, col = "red", lwd = 2)
qqnorm(y, col = "darkgreen", main = "Normal Q-Q Plot for y")
qqline(y, col = "red", lwd = 2)

# Check for extreme outliers
x_stats <- boxplot.stats(x, coef = 3)
y_stats <- boxplot.stats(y, coef = 3)
length(x_stats$out)  # Number of extreme outliers in x
length(y_stats$out)  # Number of extreme outliers in y


# Install rmarkdown if needed

install.packages("rmarkdown")

library(rmarkdown)
setwd("/Users/pvishnoi/personal-work/Northwestern/MDS401/")  # Your file location
render("Vishnoi_Prem_Assignment1a.Rmd", output_format = "all")
