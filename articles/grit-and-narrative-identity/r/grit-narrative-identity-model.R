# Grit and Narrative Identity
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, admit, discipline, or assess real people.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

narrative_coherence <- rnorm(n)
agency <- rnorm(n)
meaning_making <- rnorm(n)
future_orientation <- rnorm(n)

narrative_identity <- (
  0.28 * narrative_coherence +
  0.26 * agency +
  0.24 * meaning_making +
  0.22 * future_orientation
)

social_support <- rnorm(n)
feedback_quality <- rnorm(n)
opportunity_access <- rnorm(n)
health_stability <- rnorm(n)
institutional_trust <- rnorm(n)

burnout <- (
  0.18 * grit -
  0.22 * social_support -
  0.20 * health_stability -
  0.16 * institutional_trust +
  rnorm(n)
)

narrative_strain <- (
  0.22 * burnout -
  0.24 * social_support -
  0.20 * institutional_trust -
  0.18 * agency +
  rnorm(n)
)

grit_narrative_interaction <- grit * narrative_identity

long_term_persistence <- (
  0.18 * grit +
  0.24 * narrative_identity +
  0.12 * grit_narrative_interaction +
  0.18 * social_support +
  0.16 * feedback_quality +
  0.18 * opportunity_access +
  0.14 * institutional_trust -
  0.18 * burnout -
  0.10 * narrative_strain +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  narrative_coherence,
  agency,
  meaning_making,
  future_orientation,
  narrative_identity,
  social_support,
  feedback_quality,
  opportunity_access,
  health_stability,
  institutional_trust,
  burnout,
  narrative_strain,
  grit_narrative_interaction,
  long_term_persistence
)

grit_median <- median(df$grit)
narrative_median <- median(df$narrative_identity)

df$profile <- ifelse(
  df$grit >= grit_median & df$narrative_identity >= narrative_median,
  "high_grit_high_narrative_identity",
  ifelse(
    df$grit >= grit_median & df$narrative_identity < narrative_median,
    "high_grit_low_narrative_identity",
    ifelse(
      df$grit < grit_median & df$narrative_identity >= narrative_median,
      "low_grit_high_narrative_identity",
      "low_grit_low_narrative_identity"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-narrative-identity-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "narrative_identity",
  "agency",
  "meaning_making",
  "future_orientation",
  "social_support",
  "institutional_trust",
  "burnout",
  "narrative_strain",
  "long_term_persistence"
)])

write.csv(correlations, "outputs/tables/grit-narrative-identity-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    long_term_persistence,
    grit,
    narrative_identity,
    agency,
    meaning_making,
    future_orientation,
    social_support,
    institutional_trust,
    burnout,
    narrative_strain
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-narrative-identity-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(long_term_persistence ~ grit, data = df)

model_grit_narrative <- lm(
  long_term_persistence ~ grit + narrative_identity,
  data = df
)

model_interaction <- lm(
  long_term_persistence ~ grit + narrative_identity + grit_narrative_interaction,
  data = df
)

model_contextual <- lm(
  long_term_persistence ~ grit + narrative_identity + grit_narrative_interaction +
    social_support + feedback_quality + opportunity_access +
    health_stability + institutional_trust + burnout + narrative_strain,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only",
    "grit_plus_narrative_identity",
    "grit_narrative_interaction",
    "contextual_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_grit_narrative)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_grit_narrative)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-narrative-identity-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-narrative-identity-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
