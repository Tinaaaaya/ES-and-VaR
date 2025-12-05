Files: 
- R Markdown (AMZ—code.rmd), 
- HTML output (AMZ—code.html)
- full analysis report (analysis.pdf)

This project implements a comprehensive volatility modeling and tail-risk forecasting framework using:
- Four GARCH-family models: sGARCH, eGARCH, GJR-GARCH, apARCH
- Three innovation distributions: Gaussian, Student's t, Skewed Student's t
- Two major risk measures: Value at Risk (VaR) and Expected Shortfall (ES)
- Full rolling-window forecasting and statistical backtesting

The goal is to examine how model structure and distributional assumptions jointly affect tail-risk estimation, and whether Expected Shortfall outperforms VaR under high-volatility environments.

Key Findings
- Distribution matters more than model structure
- ES is systematically more robust than VaR
- apARCH + skew-t tends to deliver the strongest overall performance
- Gaussian-based GARCH models are overly conservative
