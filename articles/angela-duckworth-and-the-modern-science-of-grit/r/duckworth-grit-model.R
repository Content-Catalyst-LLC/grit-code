# Angela Duckworth and the Modern Science of Grit
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 750

perseverance_effort <- rnorm(n)
consistency_interest <- rnorm(n)

conscientiousness <- 0.60 * perseverance_effort + rnorm(n, sd = 0.80)
self_control <- 0.45 * perseverance_effort + rnorm(n, sd = 0.90)
social_support <- rnorm(n)
prior_achievement <- rnorm(n)

grit_score <- 0.60 * perseverance_effort + 0.40 * consistency_interest

achievement_outcome <- (
  0.18 * grit_score +
  0.34 * prior_achievement +
  0.22 * conscientiousness +
  0.15 * self_control +
  0.25 * social_support +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interest,
  grit_score,
  conscientiousness,
  self_control,
  social_support,
  prior_achievement,
  achievement_outcome
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/duckworth-grit-modeled-data-r.csv", row.names = FALSE)

model_grit_only <- lm(achievement_outcome ~ grit_score, data = df)

model_contextual <- lm(
  achievement_outcome ~ grit_score + prior_achievement +
    conscientiousness + self_control + social_support,
  data = df
)

comparison <- data.frame(
  model = c("grit_only", "grit_plus_controls"),
  r_squared = c(summary(model_grit_only)$r.squared, summary(model_contextual)$r.squared),
  adjusted_r_squared = c(summary(model_grit_only)$adj.r.squared, summary(model_contextual)$adj.r.squared),
  grit_coefficient = c(coef(model_grit_only)["grit_score"], coef(model_contextual)["grit_score"])
)

write.csv(comparison, "outputs/tables/duckworth-grit-model-comparison-r.csv", row.names = FALSE)

print(round(comparison, 4))
