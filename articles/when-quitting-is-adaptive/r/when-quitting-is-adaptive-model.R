# When Quitting Is Adaptive
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, admit, discipline, or assess real people.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

cumulative_cost <- rnorm(n)
health_risk <- rnorm(n)
goal_misalignment <- rnorm(n)
opportunity_cost <- rnorm(n)

future_value <- rnorm(n)
learning_potential <- rnorm(n)
purpose_alignment <- rnorm(n)

social_support <- rnorm(n)
financial_security <- rnorm(n)
feedback_responsiveness <- rnorm(n)
sunk_cost <- rnorm(n)
identity_pressure <- rnorm(n)

alternative_meaning <- rnorm(n)
alternative_feasibility <- rnorm(n)
alternative_support <- rnorm(n)
transition_cost <- rnorm(n)

alternative_goal_value <- (
  0.30 * alternative_meaning +
  0.28 * alternative_feasibility +
  0.24 * alternative_support -
  0.18 * transition_cost
)

quitting_pressure <- (
  0.24 * cumulative_cost +
  0.26 * health_risk +
  0.24 * goal_misalignment +
  0.20 * opportunity_cost -
  0.24 * future_value -
  0.20 * learning_potential -
  0.24 * purpose_alignment
)

overpersistence_risk <- (
  0.18 * grit +
  0.24 * sunk_cost +
  0.24 * identity_pressure -
  0.24 * feedback_responsiveness -
  0.22 * purpose_alignment +
  rnorm(n)
)

adaptive_quitting_readiness <- (
  0.28 * quitting_pressure +
  0.26 * alternative_goal_value +
  0.18 * social_support +
  0.16 * financial_security +
  0.16 * feedback_responsiveness -
  0.20 * overpersistence_risk +
  rnorm(n)
)

sustainable_persistence <- (
  0.20 * grit +
  0.26 * purpose_alignment +
  0.22 * future_value +
  0.20 * learning_potential +
  0.18 * feedback_responsiveness +
  0.16 * social_support -
  0.26 * quitting_pressure -
  0.18 * health_risk +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  cumulative_cost,
  health_risk,
  goal_misalignment,
  opportunity_cost,
  future_value,
  learning_potential,
  purpose_alignment,
  social_support,
  financial_security,
  feedback_responsiveness,
  sunk_cost,
  identity_pressure,
  alternative_meaning,
  alternative_feasibility,
  alternative_support,
  transition_cost,
  alternative_goal_value,
  quitting_pressure,
  overpersistence_risk,
  adaptive_quitting_readiness,
  sustainable_persistence
)

pressure_median <- median(df$quitting_pressure)
alternative_median <- median(df$alternative_goal_value)

df$profile <- ifelse(
  df$quitting_pressure >= pressure_median & df$alternative_goal_value >= alternative_median,
  "high_pressure_high_alternative",
  ifelse(
    df$quitting_pressure >= pressure_median & df$alternative_goal_value < alternative_median,
    "high_pressure_low_alternative",
    ifelse(
      df$quitting_pressure < pressure_median & df$alternative_goal_value >= alternative_median,
      "low_pressure_high_alternative",
      "low_pressure_low_alternative"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/when-quitting-is-adaptive-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "quitting_pressure",
  "alternative_goal_value",
  "overpersistence_risk",
  "purpose_alignment",
  "feedback_responsiveness",
  "health_risk",
  "adaptive_quitting_readiness",
  "sustainable_persistence"
)])

write.csv(correlations, "outputs/tables/when-quitting-is-adaptive-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    adaptive_quitting_readiness,
    sustainable_persistence,
    overpersistence_risk,
    grit,
    quitting_pressure,
    alternative_goal_value,
    purpose_alignment,
    health_risk,
    feedback_responsiveness,
    social_support
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/when-quitting-is-adaptive-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(adaptive_quitting_readiness ~ grit, data = df)

model_decision <- lm(
  adaptive_quitting_readiness ~ quitting_pressure + alternative_goal_value +
    social_support + financial_security,
  data = df
)

model_overpersistence <- lm(
  overpersistence_risk ~ grit + sunk_cost + identity_pressure +
    feedback_responsiveness + purpose_alignment,
  data = df
)

model_sustainable <- lm(
  sustainable_persistence ~ grit + purpose_alignment + future_value +
    learning_potential + feedback_responsiveness + social_support +
    quitting_pressure + health_risk,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only_adaptive_quitting",
    "decision_context_adaptive_quitting",
    "overpersistence_risk_model",
    "sustainable_persistence_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_decision)$r.squared,
    summary(model_overpersistence)$r.squared,
    summary(model_sustainable)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_decision)$adj.r.squared,
    summary(model_overpersistence)$adj.r.squared,
    summary(model_sustainable)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/when-quitting-is-adaptive-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_decision)$coefficients,
  "outputs/tables/when-quitting-is-adaptive-adaptive-quitting-coefficients-r.csv"
)
write.csv(
  summary(model_overpersistence)$coefficients,
  "outputs/tables/when-quitting-is-adaptive-overpersistence-coefficients-r.csv"
)
write.csv(
  summary(model_sustainable)$coefficients,
  "outputs/tables/when-quitting-is-adaptive-sustainable-persistence-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_decision)$coefficients, 4))
print(round(summary(model_overpersistence)$coefficients, 4))
print(round(summary(model_sustainable)$coefficients, 4))
