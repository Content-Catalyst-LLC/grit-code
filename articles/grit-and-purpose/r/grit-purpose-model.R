# Grit and Purpose
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, admit, discipline, or assess real people.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

personal_meaning <- rnorm(n)
long_term_direction <- rnorm(n)
beyond_self_contribution <- rnorm(n)

purpose <- (
  0.34 * personal_meaning +
  0.33 * long_term_direction +
  0.33 * beyond_self_contribution
)

social_support <- rnorm(n)
feedback_quality <- rnorm(n)
opportunity_access <- rnorm(n)
autonomy_support <- rnorm(n)
health_stability <- rnorm(n)

burnout <- (
  0.18 * grit +
  0.16 * purpose -
  0.24 * social_support -
  0.22 * autonomy_support -
  0.20 * health_stability +
  rnorm(n)
)

grit_purpose_interaction <- grit * purpose

long_term_persistence <- (
  0.20 * grit +
  0.26 * purpose +
  0.12 * grit_purpose_interaction +
  0.18 * social_support +
  0.16 * feedback_quality +
  0.18 * opportunity_access +
  0.16 * autonomy_support -
  0.20 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  personal_meaning,
  long_term_direction,
  beyond_self_contribution,
  purpose,
  social_support,
  feedback_quality,
  opportunity_access,
  autonomy_support,
  health_stability,
  burnout,
  grit_purpose_interaction,
  long_term_persistence
)

grit_median <- median(df$grit)
purpose_median <- median(df$purpose)

df$profile <- ifelse(
  df$grit >= grit_median & df$purpose >= purpose_median,
  "high_grit_high_purpose",
  ifelse(
    df$grit >= grit_median & df$purpose < purpose_median,
    "high_grit_low_purpose",
    ifelse(
      df$grit < grit_median & df$purpose >= purpose_median,
      "low_grit_high_purpose",
      "low_grit_low_purpose"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-purpose-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "purpose",
  "social_support",
  "feedback_quality",
  "opportunity_access",
  "autonomy_support",
  "health_stability",
  "burnout",
  "long_term_persistence"
)])

write.csv(correlations, "outputs/tables/grit-purpose-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    long_term_persistence,
    grit,
    purpose,
    social_support,
    opportunity_access,
    autonomy_support,
    health_stability,
    burnout
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-purpose-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(long_term_persistence ~ grit, data = df)
model_grit_purpose <- lm(long_term_persistence ~ grit + purpose, data = df)

model_interaction <- lm(
  long_term_persistence ~ grit + purpose + grit_purpose_interaction,
  data = df
)

model_contextual <- lm(
  long_term_persistence ~ grit + purpose + grit_purpose_interaction +
    social_support + feedback_quality + opportunity_access +
    autonomy_support + health_stability + burnout,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only",
    "grit_plus_purpose",
    "grit_purpose_interaction",
    "contextual_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_grit_purpose)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_grit_purpose)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-purpose-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-purpose-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
