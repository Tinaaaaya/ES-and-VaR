# ES Violations and Gap
es_stats <- risk_forecasts %>%
  pivot_longer(cols = c(VaR_95, VaR_99), names_to = "VaR_Type", values_to = "VaR_Val") %>%
  pivot_longer(cols = c(ES_95, ES_99), names_to = "ES_Type", values_to = "ES_Val") %>%
  filter(str_sub(VaR_Type, -2) == str_sub(ES_Type, -2)) %>% # Match 95 to 95
  mutate(Level = ifelse(grepl("99", VaR_Type), 0.99, 0.95)) %>%
  group_by(Model, Dist, Level) %>%
  summarise(
    VaR_Viol_Rate = mean(Realized < VaR_Val),
    ES_Viol_Rate  = mean(Realized < ES_Val),
    Avg_Gap       = mean(ES_Val - VaR_Val), # Should be negative
    .groups = "drop"
  )

print(knitr::kable(es_stats, digits = 4, caption = "Table 4 Logic: Coverage Comparison"))

# Heatmap Plot (Figure 3)
p_heatmap <- ggplot(es_stats, aes(x = Model, y = Dist, fill = Avg_Gap)) +
  geom_tile(color = "white") +
  facet_wrap(~Level, labeller = label_both) +
  geom_text(aes(label = round(Avg_Gap, 3)), color = "black", size = 3) +
  scale_fill_gradient2(low = "#3498db", mid = "white", high = "#e74c3c", midpoint = 0) +
  labs(
    title = "Average Gap: ES - VaR",
    subtitle = "Negative values indicate ES is more conservative than VaR",
    x = "Volatility Model", y = "Distribution", fill = "Gap"
  ) +
  theme_minimal() +
  theme(panel.grid = element_blank())

print(p_heatmap)