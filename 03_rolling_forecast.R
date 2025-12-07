# Configuration
n_start     <- 1000 # Estimation window size
refit_every <- 50   # Re-estimate parameters every 50 days (Standard Professional Practice)
window_type <- "moving"

# Function to run rolling forecast and extract density parameters
run_roll <- function(model, dist, data, n_start, refit_every) {
  spec <- get_spec(model, dist)
  
  # Professional Tip: Use cluster for speed if needed, but for this size single core is safer for stability
  roll <- tryCatch({
    ugarchroll(
      spec, data, n.start = n_start, 
      refit.every = refit_every, refit.window = window_type,
      solver = "hybrid", calculate.VaR = FALSE, keep.coef = TRUE
    )
  }, error = function(e) return(NULL))
  
  if (is.null(roll)) return(NULL)
  
  # Extract density parameters (Mu, Sigma, Skew, Shape)
  # This allows us to calculate EXACT VaR and ES later without simulation
  df <- as.data.frame(roll)
  
  # Clean up column names which can be inconsistent in rugarch
  colnames(df)[grep("Mu", colnames(df))] <- "Mu"
  colnames(df)[grep("Sigma", colnames(df))] <- "Sigma"
  colnames(df)[grep("Skew", colnames(df))] <- "Skew"
  colnames(df)[grep("Shape", colnames(df))] <- "Shape"
  
  # Return tidy frame
  tibble(
    Date = as.Date(rownames(df)),
    Realized = df$Realized,
    Mu = df$Mu,
    Sigma = df$Sigma,
    Skew = if("Skew" %in% colnames(df)) df$Skew else NA,
    Shape = if("Shape" %in% colnames(df)) df$Shape else NA,
    Model = model,
    Dist = dist
  )
}

# Execution Loop (Sequential for safety, can be parallelized)
cat("Starting Rolling Forecasts... (This may take a few minutes)\n")
roll_results_list <- list()
counter <- 1

for(m in models) {
  for(d in dists) {
    cat(sprintf("Rolling [%d/12]: %s - %s\n", counter, m, d))
    roll_results_list[[counter]] <- run_roll(m, d, ret, n_start, refit_every)
    counter <- counter + 1
  }
}

roll_data <- bind_rows(roll_results_list) %>% drop_na(Mu, Sigma)