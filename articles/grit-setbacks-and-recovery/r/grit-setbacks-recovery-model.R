# Grit, Setbacks, and Recovery
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, admit, discipline, or assess real people.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

setback_severity <- rnorm(n)
emotional_recovery <- rnorm(n)
cognitive_recovery <- rnorm(n)
physical_restoration <- rnorm(n)
social_support <- rnorm(n)
practical_resources <- rnorm(n)
feedback_quality <- rnorm(n)
opportunity_access <- rnorm(n)

recovery_capacity <- (
  0.22 * emotional_recovery +
  0.22 * cognitive_recovery +
  0.18 * physical_restoration +
  0.20 * social_support +
  0.18 * practical_resources
)

burnout <- (
  0.24 * setback_severity +
  0.18 * grit -
  0.24 * recovery_capacity -
  0.20 * social_support +
  rnorm(n)
)

grit_recovery_interaction <- grit * recovery_capacity

adaptive_persistence <- (
  0.18 * grit -
  0.22 * setback_severity +
  0.28 * recovery_capacity +
  0.12 * grit_recovery_interaction +
  0.18 * feedback_quality +
  0.18 * opportunity_access +
  0.14 * social_support -
  0.20 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  setback_severity,
  emotional_recovery,
  cognitive_recovery,
  physical_restoration,
  social_support,
  practical_resources,
  feedback_quality,
  opportunity_access,
  recovery_capacity,
  burnout,
  grit_recovery_interaction,
  adaptive_persistence
)

grit_median <- median(df$grit)
recovery_median <- median(df$recovery_capacity)

df$profile <- ifelse(
  df$grit >= grit_median & df$recovery_capacity >= recovery_median,
  "high_grit_high_recovery",
  ifelse(
    df$grit >= grit_median & df$recovery_capacity < recovery_median,
    "high_grit_low_recovery",
    ifelse(
      df$grit < grit_median & df$recovery_capacity >= recovery_median,
      "low_grit_high_recovery",
      "low_grit_low_recovery"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-setbacks-recovery-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "setback_severity",
  "recovery_capacity",
  "social_support",
  "feedback_quality",
  "opportunity_access",
  "burnout",
  "adaptive_persistence"
)])

write.csv(correlations, "outputs/tables/grit-setbacks-recovery-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    adaptive_persistence,
    grit,
    setback_severity,
    recovery_capacity,
    emotional_recovery,
    cognitive_recovery,
    social_support,
    feedback_quality,
    burnout
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-setbacks-recovery-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(adaptive_persistence ~ grit, data = df)

model_recovery <- lm(
  adaptive_persistence ~ grit + setback_severity + recovery_capacity,
  data = df
)

model_interaction <- lm(
  adaptive_persistence ~ grit + setback_severity + recovery_capacity + grit_recovery_interaction,
  data = df
)

model_contextual <- lm(
  adaptive_persistence ~ grit + setback_severity + recovery_capacity +
    grit_recovery_interaction + social_support + feedback_quality +
    opportunity_access + burnout,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only",
    "grit_setback_recovery",
    "grit_recovery_interaction",
    "contextual_recovery_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_recovery)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_recovery)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-setbacks-recovery-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-setbacks-recovery-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
