# Perseverance and Passion for Long-Term Goals
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 700

perseverance_effort <- rnorm(n)
durable_passion <- rnorm(n)

conscientiousness <- 0.55 * perseverance_effort + rnorm(n, sd = 0.85)
social_support <- rnorm(n)
prior_achievement <- rnorm(n)

grit_score <- 0.60 * perseverance_effort + 0.40 * durable_passion

long_term_outcome <- (
  0.22 * grit_score +
  0.34 * prior_achievement +
  0.24 * conscientiousness +
  0.26 * social_support +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  durable_passion,
  grit_score,
  conscientiousness,
  social_support,
  prior_achievement,
  long_term_outcome
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/perseverance-passion-modeled-data-r.csv", row.names = FALSE)

model_grit_only <- lm(long_term_outcome ~ grit_score, data = df)

model_contextual <- lm(
  long_term_outcome ~ grit_score + prior_achievement +
    conscientiousness + social_support,
  data = df
)

comparison <- data.frame(
  model = c("grit_only", "grit_plus_controls"),
  r_squared = c(summary(model_grit_only)$r.squared, summary(model_contextual)$r.squared),
  adjusted_r_squared = c(summary(model_grit_only)$adj.r.squared, summary(model_contextual)$adj.r.squared),
  grit_coefficient = c(coef(model_grit_only)["grit_score"], coef(model_contextual)["grit_score"])
)

write.csv(comparison, "outputs/tables/perseverance-passion-model-comparison-r.csv", row.names = FALSE)

print(round(comparison, 4))
