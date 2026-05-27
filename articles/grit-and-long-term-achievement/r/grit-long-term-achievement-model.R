# Grit and Long-Term Achievement
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

prior_preparation <- rnorm(n)
deliberate_practice <- 0.35 * grit + 0.25 * prior_preparation + rnorm(n)
feedback_quality <- rnorm(n)
social_support <- rnorm(n)
opportunity_access <- rnorm(n)
health_stability <- rnorm(n)

burnout <- (
  0.20 * grit +
  0.18 * deliberate_practice -
  0.25 * social_support -
  0.20 * health_stability +
  rnorm(n)
)

long_term_achievement <- (
  0.16 * grit +
  0.30 * deliberate_practice +
  0.26 * prior_preparation +
  0.18 * feedback_quality +
  0.20 * social_support +
  0.24 * opportunity_access +
  0.14 * health_stability -
  0.18 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  prior_preparation,
  deliberate_practice,
  feedback_quality,
  social_support,
  opportunity_access,
  health_stability,
  burnout,
  long_term_achievement
)

grit_median <- median(df$grit)
opportunity_median <- median(df$opportunity_access)

df$profile <- ifelse(
  df$grit >= grit_median & df$opportunity_access >= opportunity_median,
  "high_grit_high_opportunity",
  ifelse(
    df$grit >= grit_median & df$opportunity_access < opportunity_median,
    "high_grit_low_opportunity",
    ifelse(
      df$grit < grit_median & df$opportunity_access >= opportunity_median,
      "low_grit_high_opportunity",
      "low_grit_low_opportunity"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-long-term-achievement-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "deliberate_practice",
  "prior_preparation",
  "feedback_quality",
  "social_support",
  "opportunity_access",
  "health_stability",
  "burnout",
  "long_term_achievement"
)])

write.csv(correlations, "outputs/tables/grit-long-term-achievement-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    long_term_achievement,
    grit,
    deliberate_practice,
    social_support,
    opportunity_access,
    health_stability,
    burnout
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-long-term-achievement-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(long_term_achievement ~ grit, data = df)

model_practice <- lm(
  long_term_achievement ~ grit + deliberate_practice + prior_preparation,
  data = df
)

model_contextual <- lm(
  long_term_achievement ~ grit + deliberate_practice + prior_preparation +
    feedback_quality + social_support + opportunity_access +
    health_stability + burnout,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only",
    "grit_practice_preparation",
    "contextual_achievement_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_practice)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_practice)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-long-term-achievement-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-long-term-achievement-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
