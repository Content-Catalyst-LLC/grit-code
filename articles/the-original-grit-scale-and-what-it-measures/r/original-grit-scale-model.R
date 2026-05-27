# The Original Grit Scale and What It Measures
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.
# This script does not reproduce copyrighted scale items.

set.seed(42)

n <- 900

perseverance_effort <- rnorm(n)
consistency_interest <- rnorm(n)

# Synthetic item-style indicators. These are not actual Grit Scale items.
pe_items <- data.frame(
  pe_1 = perseverance_effort + rnorm(n, sd = 0.60),
  pe_2 = perseverance_effort + rnorm(n, sd = 0.60),
  pe_3 = perseverance_effort + rnorm(n, sd = 0.60),
  pe_4 = perseverance_effort + rnorm(n, sd = 0.60),
  pe_5 = perseverance_effort + rnorm(n, sd = 0.60),
  pe_6 = perseverance_effort + rnorm(n, sd = 0.60)
)

ci_items <- data.frame(
  ci_1 = consistency_interest + rnorm(n, sd = 0.60),
  ci_2 = consistency_interest + rnorm(n, sd = 0.60),
  ci_3 = consistency_interest + rnorm(n, sd = 0.60),
  ci_4 = consistency_interest + rnorm(n, sd = 0.60),
  ci_5 = consistency_interest + rnorm(n, sd = 0.60),
  ci_6 = consistency_interest + rnorm(n, sd = 0.60)
)

perseverance_score <- rowMeans(pe_items)
consistency_score <- rowMeans(ci_items)
grit_score <- rowMeans(data.frame(perseverance_score, consistency_score))

conscientiousness <- 0.60 * perseverance_effort + rnorm(n, sd = 0.80)
social_support <- rnorm(n)
prior_achievement <- rnorm(n)

long_term_outcome <- (
  0.20 * grit_score +
  0.34 * prior_achievement +
  0.24 * conscientiousness +
  0.25 * social_support +
  rnorm(n)
)

df <- data.frame(
  perseverance_score,
  consistency_score,
  grit_score,
  conscientiousness,
  social_support,
  prior_achievement,
  long_term_outcome
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/original-grit-scale-modeled-data-r.csv", row.names = FALSE)

average_inter_item_correlation <- function(items) {
  cormat <- cor(items)
  mean(cormat[upper.tri(cormat)])
}

reliability_summary <- data.frame(
  facet = c("perseverance_effort", "consistency_interest"),
  average_inter_item_correlation = c(
    average_inter_item_correlation(pe_items),
    average_inter_item_correlation(ci_items)
  )
)

write.csv(
  reliability_summary,
  "outputs/tables/original-grit-scale-reliability-summary-r.csv",
  row.names = FALSE
)

model_grit_only <- lm(long_term_outcome ~ grit_score, data = df)

model_facets <- lm(
  long_term_outcome ~ perseverance_score + consistency_score,
  data = df
)

model_contextual <- lm(
  long_term_outcome ~ grit_score + prior_achievement +
    conscientiousness + social_support,
  data = df
)

comparison <- data.frame(
  model = c("grit_only", "facets_only", "grit_plus_controls"),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_facets)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_facets)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(
  comparison,
  "outputs/tables/original-grit-scale-model-comparison-r.csv",
  row.names = FALSE
)

print(round(reliability_summary, 3))
print(round(comparison, 4))
