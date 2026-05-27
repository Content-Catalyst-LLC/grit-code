# Grit, Burnout, and the Risks of Overpersistence
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, admit, discipline, or assess real people.

set.seed(42)

n <- 1000

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

demand_intensity <- rnorm(n)
goal_rigidity <- rnorm(n)
identity_pressure <- rnorm(n)
sunk_cost <- rnorm(n)
recovery_capacity <- rnorm(n)
social_support <- rnorm(n)
autonomy <- rnorm(n)
feedback_responsiveness <- rnorm(n)
goal_fit <- rnorm(n)

overpersistence <- (
  0.22 * grit +
  0.24 * sunk_cost +
  0.22 * identity_pressure +
  0.20 * goal_rigidity -
  0.22 * feedback_responsiveness -
  0.20 * goal_fit +
  rnorm(n)
)

burnout_risk <- (
  0.24 * demand_intensity +
  0.22 * overpersistence +
  0.18 * goal_rigidity +
  0.16 * grit -
  0.26 * recovery_capacity -
  0.20 * social_support -
  0.18 * autonomy +
  rnorm(n)
)

sustainable_persistence <- (
  0.20 * grit +
  0.24 * goal_fit +
  0.22 * feedback_responsiveness +
  0.20 * recovery_capacity +
  0.18 * social_support +
  0.18 * autonomy -
  0.24 * burnout_risk -
  0.16 * overpersistence +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  demand_intensity,
  goal_rigidity,
  identity_pressure,
  sunk_cost,
  recovery_capacity,
  social_support,
  autonomy,
  feedback_responsiveness,
  goal_fit,
  overpersistence,
  burnout_risk,
  sustainable_persistence
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

write.csv(df, "data/processed/grit-burnout-overpersistence-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "demand_intensity",
  "goal_rigidity",
  "identity_pressure",
  "sunk_cost",
  "recovery_capacity",
  "social_support",
  "autonomy",
  "feedback_responsiveness",
  "goal_fit",
  "overpersistence",
  "burnout_risk",
  "sustainable_persistence"
)])

write.csv(correlations, "outputs/tables/grit-burnout-overpersistence-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    sustainable_persistence,
    burnout_risk,
    overpersistence,
    grit,
    recovery_capacity,
    goal_fit,
    feedback_responsiveness,
    social_support,
    autonomy
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-burnout-overpersistence-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(burnout_risk ~ grit, data = df)

model_overpersistence <- lm(
  burnout_risk ~ grit + demand_intensity + goal_rigidity + overpersistence,
  data = df
)

model_burnout <- lm(
  burnout_risk ~ grit + demand_intensity + goal_rigidity + overpersistence +
    recovery_capacity + social_support + autonomy,
  data = df
)

model_sustainable <- lm(
  sustainable_persistence ~ grit + goal_fit + feedback_responsiveness +
    recovery_capacity + social_support + autonomy + burnout_risk +
    overpersistence,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only_burnout",
    "demand_overpersistence_burnout",
    "contextual_burnout_model",
    "sustainable_persistence_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_overpersistence)$r.squared,
    summary(model_burnout)$r.squared,
    summary(model_sustainable)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_overpersistence)$adj.r.squared,
    summary(model_burnout)$adj.r.squared,
    summary(model_sustainable)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-burnout-overpersistence-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_burnout)$coefficients,
  "outputs/tables/grit-burnout-overpersistence-burnout-coefficients-r.csv"
)
write.csv(
  summary(model_sustainable)$coefficients,
  "outputs/tables/grit-burnout-overpersistence-sustainable-persistence-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_burnout)$coefficients, 4))
print(round(summary(model_sustainable)$coefficients, 4))
