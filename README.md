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

### 1. Summary

This project develops a complete volatility modeling and tail-risk forecasting framework for Amazon (AMZN) using daily returns from 2019–2025. The analysis compares four GARCH-family models (sGARCH, eGARCH, GJR-GARCH, apARCH) under multiple distributional assumptions (Normal, Student-t, skew-Student-t). A rolling-window forecasting system is implemented to generate out-of-sample estimates of Value-at-Risk (VaR) and Expected Shortfall (ES), followed by formal backtesting at 95% and 99% confidence levels. Results show that heavy-tailed distributions combined with asymmetric volatility models provide the most accurate risk forecasts, with eGARCH–Student-t emerging as the strongest overall performer.

### 2. Key Figures
<img width="1344" height="960" alt="8853588274337230c615931623b2e5db" src="https://github.com/user-attachments/assets/8effc9fd-785e-4a70-abef-51ef4915530a" />

### 3. Final Conclusions

Across all model–distribution combinations, fat-tailed innovations (Student-t, skew-Student-t) significantly outperform Gaussian assumptions, capturing the heavy-tailed nature of AMZN returns. Asymmetric volatility models—particularly eGARCH—successfully detect leverage effects where negative shocks generate disproportionately higher volatility.

Rolling forecasting and backtesting results reinforce these findings. At both 95% and 99% confidence levels, eGARCH–t and eGARCH–skew-t achieve violation rates closest to theoretical targets and pass the Kupiec and Christoffersen tests for unconditional and conditional coverage. Expected Shortfall consistently provides more conservative tail estimates and demonstrates greater robustness to extreme events.

Overall, the most reliable risk forecasts are obtained by combining:
- **asymmetric volatility dynamics (eGARCH, GJR-GARCH), and**
- **heavy-tailed distributions (Student-t, skew-t).**

This highlights the importance of accurately modeling both volatility asymmetry and distributional tail risk in practical financial risk-management applications.
