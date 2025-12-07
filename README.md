## Files: 
- R code 
- HTML output (AMZ—code.html)

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

### 3. Key Tables
Table 1: eGARCH-sstd captures both the leverage effects inherent in equity returns and the heavier-than-normal tails observed in the empirical distribution. The skewed Student’s t remains a good secondary choice, particularly if capturing asymmetric tail risk is of interest. These results form the basis for later value-at-risk and expected shortfall analysis, where model performance will be validated through backtesting procedures.

Table 1: Summary of GARCH-family model estimates for AMZN returns.
| Model | Dist | Conv | Pers | Skew | Shape | AIC | BIC |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| apARCH | norm | 0 | 1.1696 | - | - | -5.0122 | -4.9910 |
| apARCH | sstd | 0 | 1.2297 | 0.9655 | 5.7350 | -5.0723 | -5.0441 |
| apARCH | std | 0 | 1.2222 | - | 5.7662 | -5.0730 | -5.0483 |
| eGARCH | norm | 0 | 0.9500 | - | - | -5.0105 | -4.9929 |
| eGARCH | sstd | 0 | 0.9829 | - | 5.6805 | -5.0737 | -5.0525 |
| eGARCH | std | 0 | 0.9831 | 0.9650 | 5.6547 | -5.0730 | -5.0483 |
| girGARCH | norm | 0 | 0.9527 | - | - | -4.9960 | -4.9783 |
| girGARCH | sstd | 0 | 0.9912 | 0.9660 | 5.3248 | -5.0614 | -5.0367 |
| girGARCH | std | 0 | 0.9904 | - | 5.3352 | -5.0621 | -5.0410 |
| sGARCH | norm | 0 | 0.9485 | - | - | -4.9919 | -4.9778 |
| sGARCH | sstd | 0 | 0.9943 | 0.9706 | 5.1591 | -5.0600 | -5.0388 |
| sGARCH | std | 0 | 0.9940 | - | 5.1637 | -5.0609 | -5.0432 |

Table 2: A rolling-window evaluation of Value-at-Risk (VaR) and Expected Shortfall (ES) demonstrates clear differences across combinations. At the 95% confidence level, specifications with fat-tailed distributions (std, sstd) produce coverage rates close to the nominal 5% tail probability, while Gaussian-based models consistently underestimate risk (see Table 4). At the 99% level, eGARCH–std delivers the most accurate forecasts (0.98%), while normal-based apARCH proves overly aggressive (1.38%) and sstd-based models excessively conservative (<0.8%).

Complementary ES analysis shows consistently lower violation rates than VaR, confirming its greater conservatism and robustness. For instance, the sGARCH–std model reduced violations from 4.72% (VaR) to 1.18% (ES) at 95% level (Table 4). Overall, eGARCH with heavy-tailed distributions yields the most reliable VaR forecasts, while ES systematically provides stronger coverage of extreme losses.

Table 2: Coverage Comparison Between VaR and ES
| CI | Model | Dist | V Rate | ES Rate | Avg(ES-YaR) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 95% | apARCH | norm | 3.93% | 1.96% | -0.0083 |
| 95% | apARCH | sstd | 4.72% | 1.57% | -0.0128 |
| 95% | apARCH | std | 4.91% | 1.77% | -0.0124 |
| 95% | eGARCH | norm | 3.93% | 1.77% | -0.0084 |
| 95% | eGARCH | sstd | 4.91% | 1.57% | -0.0130 |
| 95% | eGARCH | std | 5.11% | 1.57% | -0.0126 |
| 95% | girGARCH | norm | 3.54% | 1.77% | -0.0085 |
| 95% | girGARCH | sstd | 4.91% | 1.57% | -0.0134 |
| 95% | girGARCH | std | 4.91% | 1.57% | -0.0130 |
| 95% | sGARCH | norm | 3.73% | 1.77% | -0.0085 |
| 95% | sGARCH | sstd | 4.52% | 1.18% | -0.0138 |
| 95% | sGARCH | std | 4.72% | 1.18% | -0.0135 |
| 99% | apARCH | norm | 1.38% | 0.79% | -0.0067 |
| 99% | apARCH | sstd | 0.98% | 0.39% | -0.0152 |
| 99% | apARCH | std | 0.98% | 0.39% | -0.0147 |
| 99% | eGARCH | norm | 1.38% | 0.79% | -0.0068 |
| 99% | eGARCH | sstd | 0.79% | 0.39% | -0.0155 |
| 99% | eGARCH | std | 0.98% | 0.39% | -0.0150 |
| 99% | girGARCH | norm | 1.18% | 0.79% | -0.0069 |
| 99% | girGARCH | sstd | 0.79% | 0.39% | -0.0164 |
| 99% | girGARCH | std | 0.79% | 0.39% | -0.0158 |
| 99% | SGARCH | norm | 1.18% | 0.59% | -0.0069 |
| 99% | sGARCH | sstd | 0.59% | 0.20% | -0.0170 |
| 99% | sGARCH | std | 0.59% | 0.20% | -0.0166 |

Table 3: At the 95% confidence level, heavy-tailed distributions consistently exhibit better statistical performance compared to the normal distribution. Models including apARCH–std, eGARCH-sstd, gjrGARCH–std, and gjrGARCH–sstd demonstrate conditional coverage with p-values nearing 0.97, indicating precise violation rates and independence of exceedances. The normal distribution consistently yields conservative Value at Risk (VaR) estimates, with empirical violation rates are 4.91%. Although these deviations are statistically acceptable (p ≈ 0.82–0.93), they suggest a tendency to overestimate risk. The apARCH and eGARCH models, when combined with heavy-tailed innovations, demonstrate strong performance, as indicated by CC p-values greater than 0.94, which implies a significant reliability in addressing the moderate tail risk environment.

Table 3: Result under 95% CI
| Model | Dist | EmpRate | p(POF) | p(Ind) | p(CC) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| apARCH | norm | 0.0393 | 0.2503 | 0.2004 | 0.2274 |
| apARCH | sstd | 0.0472 | 0.7660 | 0.8931 | 0.9481 |
| apARCH | std | 0.0491 | 0.9269 | 0.8219 | 0.9709 |
| eGARCH | norm | 0.0393 | 0.2503 | 0.2004 | 0.2274 |
| eGARCH | sstd | 0.0491 | 0.9269 | 0.8219 | 0.9709 |
| eGARCH | std | 0.0511 | 0.9112 | 0.7530 | 0.9458 |
| gjrGARCH | norm | 0.0354 | 0.1106 | 0.2501 | 0.1445 |
| gjrGARCH | sstd | 0.0491 | 0.9269 | 0.8219 | 0.9709 |
| gjrGARCH | std | 0.0491 | 0.9269 | 0.8219 | 0.9709 |
| sGARCH | norm | 0.0373 | 0.1704 | 0.2243 | 0.1867 |
| sGARCH | sstd | 0.0452 | 0.6127 | 0.9659 | 0.8790 |
| sGARCH | std | 0.0472 | 0.7660 | 0.8931 | 0.9481 |

Table 4: At the 99% confidence level, eGARCH–std, apARCH–sstd, and apARCH–std closely align with the theoretical 1% target, resulting in notably high POF p-values (~0.968) and CC p-values (~0.951). This accuracy illustrates their capacity to maintain a balance between coverage and the statistical independence of violations. In comparison, normal-distribution variants exhibit a slightly aggressive tendency, with violation rates approximately at 1.38%. sGARCH–std and sGARCH–sstd exhibit conservative behavior, demonstrating only three violations, which accounts for approximately 0.59%. Despite these deviations passing statistical backtests (p > 0.05), they indicate that heavy-tailed assumptions yield more reliable predictions for extreme risk events.

Table 4: Result under 99% CI
| Model | Dist | EmpRate | p(POF) | p(Ind) | p(CC) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| apARCH | norm | 0.0138 | 0.4208 | 0.6583 | 0.6558 |
| apARCH | sstd | 0.0098 | 0.9679 | 0.7525 | 0.9507 |
| apARCH | std | 0.0098 | 0.9679 | 0.7525 | 0.9507 |
| eGARCH | norm | 0.0138 | 0.4208 | 0.6583 | 0.6558 |
| eGARCH | sstd | 0.0079 | 0.6139 | 0.8011 | 0.8530 |
| eGARCH | std | 0.0098 | 0.9679 | 0.7525 | 0.9507 |
| girGARCH | norm | 0.0118 | 0.6934 | 0.7049 | 0.8612 |
| girGARCH | sstd | 0.0079 | 0.6139 | 0.8011 | 0.8530 |
| girGARCH | std | 0.0079 | 0.6139 | 0.8011 | 0.8530 |
| sGARCH | norm | 0.0118 | 0.6934 | 0.7049 | 0.8612 |
| sGARCH | sstd | 0.0059 | 0.3133 | 0.8503 | 0.5909 |
| sGARCH | std | 0.0059 | 0.3133 | 0.8503 | 0.5909 |

### 4. Final Conclusions

Across all model–distribution combinations, fat-tailed innovations (Student-t, skew-Student-t) significantly outperform Gaussian assumptions, capturing the heavy-tailed nature of AMZN returns. Asymmetric volatility models—particularly eGARCH—successfully detect leverage effects where negative shocks generate disproportionately higher volatility.

Rolling forecasting and backtesting results reinforce these findings. At both 95% and 99% confidence levels, eGARCH–t and eGARCH–skew-t achieve violation rates closest to theoretical targets and pass the Kupiec and Christoffersen tests for unconditional and conditional coverage. Expected Shortfall consistently provides more conservative tail estimates and demonstrates greater robustness to extreme events.

Overall, the most reliable risk forecasts are obtained by combining:
- **asymmetric volatility dynamics (eGARCH, GJR-GARCH), and**
- **heavy-tailed distributions (Student-t, skew-t).**

This highlights the importance of accurately modeling both volatility asymmetry and distributional tail risk in practical financial risk-management applications.
