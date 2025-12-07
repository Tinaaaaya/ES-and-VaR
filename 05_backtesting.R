run_backtest <- function(realized, var_forecast, alpha) {
  hits <- ifelse(realized < var_forecast, 1, 0)
  T <- length(hits)
  N <- sum(hits)
  rate <- N / T
  
  # 1. Kupiec POF (Likelihood Ratio)
  lr_pof <- -2 * ((T - N) * log(1 - alpha) + N * log(alpha) - 
                    ((T - N) * log(1 - rate) + N * log(rate)))
  # Handle edge case where N=0
  if(is.nan(lr_pof)) lr_pof <- 0 
  p_pof <- 1 - pchisq(lr_pof, df = 1)
  
  # 2. Christoffersen Independence
  # Construct transition matrix
  hits_lag <- hits[1:(T-1)]
  hits_now <- hits[2:T]
  
  n00 <- sum(hits_lag == 0 & hits_now == 0)
  n01 <- sum(hits_lag == 0 & hits_now == 1)
  n10 <- sum(hits_lag == 1 & hits_now == 0)
  n11 <- sum(hits_lag == 1 & hits_now == 1)
  
  pi0 <- n01 / (n00 + n01)
  pi1 <- n11 / (n10 + n11)
  pi  <- (n01 + n11) / (n00 + n01 + n10 + n11)
  
  # Likelihoods
  L_null <- (1 - pi)^(n00 + n10) * pi^(n01 + n11)
  L_alt  <- (1 - pi0)^n00 * pi0^n01 * (1 - pi1)^n10 * pi1^n11
  
  lr_ind <- -2 * log(L_null / L_alt)
  if(is.nan(lr_ind) || is.infinite(lr_ind)) lr_ind <- 0
  p_ind <- 1 - pchisq(lr_ind, df = 1)
  
  # 3. Conditional Coverage
  lr_cc <- lr_pof + lr_ind
  p_cc  <- 1 - pchisq(lr_cc, df = 2)
  
  return(tibble(
    N_Violations = N,
    Empirical_Rate = rate,
    p_POF = p_pof,
    p_IND = p_ind,
    p_CC  = p_cc
  ))
}

# Generate Results for 95%
bt_95 <- risk_forecasts %>%
  group_by(Model, Dist) %>%
  summarise(metrics = list(run_backtest(Realized, VaR_95, 0.05)), .groups="drop") %>%
  unnest(metrics) %>%
  mutate(Target = "95%")

# Generate Results for 99%
bt_99 <- risk_forecasts %>%
  group_by(Model, Dist) %>%
  summarise(metrics = list(run_backtest(Realized, VaR_99, 0.01)), .groups="drop") %>%
  unnest(metrics) %>%
  mutate(Target = "99%")

# Combine for display
final_backtest <- bind_rows(bt_95, bt_99) %>%
  arrange(Target, desc(p_CC))

cat("\n--- Backtesting Results (Matches Tables 5 & 6) ---\n")
print(knitr::kable(final_backtest, digits = 4))