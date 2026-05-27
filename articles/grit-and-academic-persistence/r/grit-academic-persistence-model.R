# Grit and Academic Persistence
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, admit, discipline, or assess real students.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

self_control <- rnorm(n)
prior_preparation <- rnorm(n)
instructional_quality <- rnorm(n)
feedback_quality <- rnorm(n)
belonging <- rnorm(n)
social_support <- rnorm(n)
financial_stress <- rnorm(n)
health_stability <- rnorm(n)

study_effort <- (
  0.30 * grit +
  0.26 * self_control +
  0.18 * belonging +
  0.16 * social_support -
  0.18 * financial_stress +
  rnorm(n)
)

burnout <- (
  0.22 * financial_stress +
  0.18 * study_effort -
  0.22 * social_support -
  0.20 * health_stability -
  0.16 * belonging +
  rnorm(n)
)

academic_progress <- (
  0.18 * grit +
  0.24 * study_effort +
  0.26 * prior_preparation +
  0.20 * instructional_quality +
  0.18 * feedback_quality +
  0.18 * belonging +
  0.14 * social_support -
  0.18 * burnout +
  rnorm(n)
)

academic_persistence <- (
  0.20 * grit +
  0.18 * self_control +
  0.24 * academic_progress +
  0.22 * belonging +
  0.18 * social_support -
  0.20 * financial_stress -
  0.18 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  self_control,
  prior_preparation,
  instructional_quality,
  feedback_quality,
  belonging,
  social_support,
  financial_stress,
  health_stability,
  study_effort,
  burnout,
  academic_progress,
  academic_persistence
)

grit_median <- median(df$grit)
belonging_median <- median(df$belonging)

df$profile <- ifelse(
  df$grit >= grit_median & df$belonging >= belonging_median,
  "high_grit_high_belonging",
  ifelse(
    df$grit >= grit_median & df$belonging < belonging_median,
    "high_grit_low_belonging",
    ifelse(
      df$grit < grit_median & df$belonging >= belonging_median,
      "low_grit_high_belonging",
      "low_grit_low_belonging"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-academic-persistence-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "self_control",
  "prior_preparation",
  "instructional_quality",
  "feedback_quality",
  "belonging",
  "social_support",
  "financial_stress",
  "burnout",
  "academic_progress",
  "academic_persistence"
)])

write.csv(correlations, "outputs/tables/grit-academic-persistence-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    academic_persistence,
    academic_progress,
    grit,
    belonging,
    social_support,
    financial_stress,
    burnout
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-academic-persistence-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(academic_persistence ~ grit, data = df)

model_regulation <- lm(
  academic_persistence ~ grit + self_control + study_effort + academic_progress,
  data = df
)

model_contextual <- lm(
  academic_persistence ~ grit + self_control + prior_preparation +
    instructional_quality + feedback_quality + belonging + social_support +
    financial_stress + health_stability + study_effort + burnout +
    academic_progress,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only",
    "grit_self_control_study_progress",
    "contextual_persistence_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_regulation)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_regulation)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-academic-persistence-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-academic-persistence-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
