# Load necessary libraries
library(quantmod)
library(xts)
library(tidyverse)
library(rugarch)
library(PerformanceAnalytics)
library(FinTS)
library(scales)
library(parallel)

# Set global seed for reproducibility
set.seed(123)


symbol <- "AMZN"
start_date <- "2019-01-01"
end_date   <- "2025-01-01"

# Fetch Data
px <- suppressWarnings(
  getSymbols(symbol, from = start_date, to = end_date, auto.assign = FALSE, src = "yahoo")
)

# Calculate Log Returns
# We use Adjusted Close to account for dividends/splits
prices <- Ad(px)
ret <- diff(log(prices))
ret <- ret[!is.na(ret)] # Remove the first NA created by diff

colnames(ret) <- "Return"

# Visual check of the data
cat(paste0("Data Range: ", start(ret), " to ", end(ret), "\n"))
cat(paste0("Total Observations: ", nrow(ret), "\n"))

# Stylized Facts Plots (Figure 1 & 2 in Paper)
p1 <- ret %>% 
  fortify() %>% 
  ggplot(aes(x = Index, y = Return)) +
  geom_line(color = "#2c3e50", size = 0.3) +
  labs(title = paste(symbol, "Daily Log Returns"), x = "Date", y = "Log Return") +
  theme_minimal()

p2 <- ret %>% 
  fortify() %>% 
  ggplot(aes(x = Return)) +
  geom_histogram(aes(y = ..density..), bins = 60, fill = "#3498db", alpha = 0.7) +
  geom_density(color = "#e74c3c", size = 1) +
  stat_function(fun = dnorm, args = list(mean = mean(ret), sd = sd(ret)), 
                linetype = "dashed", color = "black") +
  labs(title = "Distribution vs Normal (Dashed)", x = "Log Return", y = "Density") +
  theme_minimal()

print(p1)
print(p2)

# Arch Effects Test (Table 2 logic)
cat("\n--- Statistical Diagnostics ---\n")
print(Box.test(ret, lag = 20, type = "Ljung-Box")) # Autocorrelation
print(Box.test(ret^2, lag = 20, type = "Ljung-Box")) # ARCH effect
print(ArchTest(ret, lags = 20)) # Formal ARCH LM test
