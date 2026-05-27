# Grit in Positive Psychology
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 800

perseverance_effort <- rnorm(n)
durable_interest <- rnorm(n)

meaning <- rnorm(n)
relationships <- rnorm(n)
social_support <- 0.50 * relationships + rnorm(n, sd = 0.85)
health_resources <- rnorm(n)
depletion <- rnorm(n)

grit_score <- 0.60 * perseverance_effort + 0.40 * durable_interest

flourishing <- (
  0.18 * grit_score +
  0.30 * meaning +
  0.25 * relationships +
  0.22 * social_support +
  0.20 * health_resources -
  0.28 * depletion +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  durable_interest,
  grit_score,
  meaning,
  relationships,
  social_support,
  health_resources,
  depletion,
  flourishing
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-positive-psychology-modeled-data-r.csv", row.names = FALSE)

model_grit_only <- lm(flourishing ~ grit_score, data = df)

model_positive_psychology <- lm(
  flourishing ~ grit_score + meaning + relationships +
    social_support + health_resources + depletion,
  data = df
)

comparison <- data.frame(
  model = c("grit_only", "grit_plus_positive_psychology_context"),
  r_squared = c(summary(model_grit_only)$r.squared, summary(model_positive_psychology)$r.squared),
  adjusted_r_squared = c(summary(model_grit_only)$adj.r.squared, summary(model_positive_psychology)$adj.r.squared),
  grit_coefficient = c(coef(model_grit_only)["grit_score"], coef(model_positive_psychology)["grit_score"])
)

write.csv(comparison, "outputs/tables/grit-positive-psychology-model-comparison-r.csv", row.names = FALSE)

print(round(comparison, 4))
