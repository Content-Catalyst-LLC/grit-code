# Perseverance of Effort Versus Consistency of Interests
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 900

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)

conscientiousness <- 0.62 * perseverance_effort + rnorm(n, sd = 0.80)
self_control <- 0.45 * perseverance_effort + rnorm(n, sd = 0.90)
social_support <- rnorm(n)
prior_achievement <- rnorm(n)
burnout <- rnorm(n)

grit_total <- 0.60 * perseverance_effort + 0.40 * consistency_interests

long_term_outcome <- (
  0.28 * perseverance_effort +
  0.08 * consistency_interests +
  0.25 * prior_achievement +
  0.18 * conscientiousness +
  0.20 * social_support -
  0.22 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit_total,
  conscientiousness,
  self_control,
  social_support,
  prior_achievement,
  burnout,
  long_term_outcome
)

pe_median <- median(df$perseverance_effort)
ci_median <- median(df$consistency_interests)

df$facet_profile <- ifelse(
  df$perseverance_effort >= pe_median & df$consistency_interests >= ci_median,
  "high_effort_high_consistency",
  ifelse(
    df$perseverance_effort >= pe_median & df$consistency_interests < ci_median,
    "high_effort_low_consistency",
    ifelse(
      df$perseverance_effort < pe_median & df$consistency_interests >= ci_median,
      "low_effort_high_consistency",
      "low_effort_low_consistency"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-facet-comparison-modeled-data-r.csv", row.names = FALSE)

profile_summary <- aggregate(
  cbind(long_term_outcome, perseverance_effort, consistency_interests, burnout, social_support) ~ facet_profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-facet-profile-summary-r.csv", row.names = FALSE)

model_total_grit <- lm(long_term_outcome ~ grit_total, data = df)

model_facets <- lm(
  long_term_outcome ~ perseverance_effort + consistency_interests,
  data = df
)

model_contextual <- lm(
  long_term_outcome ~ perseverance_effort + consistency_interests +
    prior_achievement + conscientiousness + self_control +
    social_support + burnout,
  data = df
)

comparison <- data.frame(
  model = c("total_grit_only", "facets_only", "facets_plus_context"),
  r_squared = c(
    summary(model_total_grit)$r.squared,
    summary(model_facets)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_total_grit)$adj.r.squared,
    summary(model_facets)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-facet-comparison-models-r.csv", row.names = FALSE)

print(round(profile_summary, 4))
print(round(comparison, 4))
