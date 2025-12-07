# Helper: Analytical ES Calculator
calc_exact_risk <- function(mu, sigma, skew, shape, dist, alpha) {
  
  # 1. Calculate Quantile (Standardized)
  q_z <- switch(dist,
                "norm" = qdist("norm", p = alpha, mu = 0, sigma = 1),
                "std"  = qdist("std",  p = alpha, mu = 0, sigma = 1, shape = shape),
                "sstd" = qdist("sstd", p = alpha, mu = 0, sigma = 1, skew = skew, shape = shape)
  )
  
  # 2. Calculate ES (Standardized) via Integration
  # We integrate the quantile function from 0 to alpha, then divide by alpha
  es_z <- tryCatch({
    integrate(function(x) {
      switch(dist,
             "norm" = qdist("norm", p = x, mu = 0, sigma = 1),
             "std"  = qdist("std",  p = x, mu = 0, sigma = 1, shape = shape),
             "sstd" = qdist("sstd", p = x, mu = 0, sigma = 1, skew = skew, shape = shape)
      )
    }, lower = 0, upper = alpha)$value / alpha
  }, error = function(e) NA)
  
  # 3. Scale to Returns
  VaR <- mu + sigma * q_z
  ES  <- mu + sigma * es_z
  
  return(c(VaR, ES))
}

# Vectorizing the calculation is hard due to integration, so we use row-wise mapping
# We calculate for 5% and 1%
risk_forecasts <- roll_data %>%
  mutate(
    # 5% Level
    Res_05 = pmap(list(Mu, Sigma, Skew, Shape, Dist), calc_exact_risk, alpha = 0.05),
    VaR_95 = map_dbl(Res_05, 1),
    ES_95  = map_dbl(Res_05, 2),
    
    # 1% Level
    Res_01 = pmap(list(Mu, Sigma, Skew, Shape, Dist), calc_exact_risk, alpha = 0.01),
    VaR_99 = map_dbl(Res_01, 1),
    ES_99  = map_dbl(Res_01, 2)
  ) %>%
  select(-Res_05, -Res_01)

head(risk_forecasts)