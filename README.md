## Files: 
- R code 
- HTML output (AMZ—code.html)
- full analysis report (analysis.pdf)

This project implements a comprehensive volatility modeling and tail-risk forecasting framework using:
- Four GARCH-family models: sGARCH, eGARCH, GJR-GARCH, apARCH
- Three innovation distributions: Gaussian, Student's t, Skewed Student's t
- Two major risk measures: Value at Risk (VaR) and Expected Shortfall (ES)
- Full rolling-window forecasting and statistical backtesting

The goal is to examine how model structure and distributional assumptions jointly affect tail-risk estimation, and whether Expected Shortfall outperforms VaR under high-volatility environments.

## Analysis & Key Findings

This project conducts a comprehensive volatility and risk forecasting analysis for Amazon (AMZN) using daily returns from 2019–2025. The return series exhibits classic financial time-series features, which heavy tails, volatility clustering, and negligible linear autocorrelation, validated through descriptive statistics and ARCH diagnostics.

Four GARCH-family models (sGARCH, eGARCH, GJR-GARCH, apARCH) are estimated under Normal, Student-t, and skew-Student-t distributions. Heavy-tailed innovations substantially improve model fit, and asymmetric specifications consistently capture leverage effects observed in equity markets. Among all twelve model–distribution pairs, the eGARCH–Student-t and eGARCH–skew-t models achieve the lowest AIC/BIC and provide the most realistic persistence estimates, making them strong candidates for forward-looking risk evaluation.

A rolling 1,000-day estimation window with 50-day refits is used to produce out-of-sample forecasts of Value-at-Risk (VaR) and Expected Shortfall (ES). Analytical computation of quantiles and tail expectations ensures stable and efficient risk estimates.

Backtesting at the 95% and 99% confidence levels shows that models assuming heavy-tailed distributions significantly outperform Gaussian variants. Student-t and skew-t versions of eGARCH, GJR-GARCH, and sGARCH achieve violation rates closest to theoretical targets and pass conditional coverage tests, indicating strong reliability in extreme-loss prediction. ES consistently proves more conservative than VaR, particularly under heavy tails, reinforcing its value as a tail-risk metric.

Overall, the best-performing risk forecasts are obtained when combining asymmetric volatility dynamics with heavy-tailed distributions—particularly eGARCH with Student-t innovations—highlighting the importance of jointly modeling leverage effects and tail behavior in financial risk management.

Please see the results and full analysis report in analysis.md
