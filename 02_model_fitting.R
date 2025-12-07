# Define Model Combinations
models <- c("sGARCH", "eGARCH", "gjrGARCH", "apARCH")
dists  <- c("norm", "std", "sstd")
spec_grid <- crossing(model = models, dist = dists)

# Function to build spec
get_spec <- function(model_name, dist_name) {
  ugarchspec(
    variance.model = list(model = model_name, garchOrder = c(1, 1)),
    mean.model     = list(armaOrder = c(0, 0), include.mean = TRUE),
    distribution.model = dist_name
  )
}

# Fit all models
full_fits <- spec_grid %>%
  mutate(fit_obj = map2(model, dist, function(m, d) {
    tryCatch({
      ugarchfit(spec = get_spec(m, d), data = ret, solver = "hybrid")
    }, error = function(e) NULL)
  }))

# Extract Statistics for Table 3
results_table3 <- full_fits %>%
  mutate(
    Converged = map_int(fit_obj, ~ if(is.null(.x)) 1 else .x@fit$convergence),
    LogLik    = map_dbl(fit_obj, ~ if(is.null(.x)) NA else likelihood(.x)),
    AIC       = map_dbl(fit_obj, ~ if(is.null(.x)) NA else infocriteria(.x)[1]),
    BIC       = map_dbl(fit_obj, ~ if(is.null(.x)) NA else infocriteria(.x)[2]),
    # Extract coefficients safely
    Coefs     = map(fit_obj, ~ if(is.null(.x)) NULL else coef(.x))
  ) %>%
  rowwise() %>%
  mutate(
    # Persistence calculation varies by model
    Persistence = case_when(
      model == "sGARCH" ~ Coefs["alpha1"] + Coefs["beta1"],
      model == "eGARCH" ~ Coefs["beta1"], # Log-vol persistence
      model == "gjrGARCH" ~ Coefs["alpha1"] + Coefs["beta1"] + 0.5 * Coefs["gamma1"],
      model == "apARCH" ~ Coefs["alpha1"] + Coefs["beta1"] + 0.5 * Coefs["gamma1"], # Approx
      TRUE ~ NA_real_
    ),
    Shape = ifelse("shape" %in% names(Coefs), Coefs["shape"], NA),
    Skew  = ifelse("skew" %in% names(Coefs), Coefs["skew"], NA)
  ) %>%
  select(Model = model, Dist = dist, AIC, BIC, Persistence, Shape, Skew) %>%
  arrange(AIC)

# Display Table 3
print(knitr::kable(results_table3, digits = 4, caption = "Table 3: Model Estimation Results"))