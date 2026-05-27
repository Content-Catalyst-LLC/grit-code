# What Is Grit? — R synthetic-data workflow
# Synthetic data for article support and methods demonstration only.

set.seed(42)

n <- 500

perseverance_effort <- rnorm(n)
consistency_interest <- rnorm(n)
conscientiousness <- 0.55 * perseverance_effort + rnorm(n, sd = 0.85)
social_support <- rnorm(n)
prior_achievement <- rnorm(n)

grit_score <- 0.60 * perseverance_effort + 0.40 * consistency_interest

achievement_outcome <- (
  0.25 * grit_score +
  0.35 * prior_achievement +
  0.20 * conscientiousness +
  0.25 * social_support +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interest,
  grit_score,
  conscientiousness,
  social_support,
  prior_achievement,
  achievement_outcome
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/what-is-grit-modeled-data-r.csv", row.names = FALSE)

model_1 <- lm(achievement_outcome ~ grit_score, data = df)
model_2 <- lm(
  achievement_outcome ~ grit_score + prior_achievement + conscientiousness + social_support,
  data = df
)

summary_table <- data.frame(
  model = c("grit_only", "grit_plus_controls"),
  r_squared = c(summary(model_1)$r.squared, summary(model_2)$r.squared),
  adjusted_r_squared = c(summary(model_1)$adj.r.squared, summary(model_2)$adj.r.squared),
  grit_coefficient = c(coef(model_1)["grit_score"], coef(model_2)["grit_score"])
)

write.csv(summary_table, "outputs/tables/what-is-grit-regression-summary-r.csv", row.names = FALSE)

print(summary_table)
