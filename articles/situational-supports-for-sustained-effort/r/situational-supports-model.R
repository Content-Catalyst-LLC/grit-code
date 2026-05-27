# Situational supports model for sustained effort.
# Synthetic data only. Not for individual assessment, hiring, admissions, ranking, diagnosis, or discipline.

set.seed(42)

n <- 1000

age <- sample(14:69, n, replace = TRUE)

developmental_stage <- ifelse(
  age < 18,
  "adolescence",
  ifelse(age < 30, "emerging_adulthood", ifelse(age < 55, "adulthood", "later_adulthood"))
)

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

autonomy_support <- rnorm(n)
feedback_quality <- rnorm(n)
belonging <- rnorm(n)
mentoring_access <- rnorm(n)
recovery_capacity <- rnorm(n)
material_resources <- rnorm(n)
fairness <- rnorm(n)
psychological_safety <- rnorm(n)

demand_intensity <- rnorm(n)
chronic_stress <- rnorm(n)
blocked_opportunity <- rnorm(n)

situational_support <- (
  0.16 * autonomy_support +
  0.16 * feedback_quality +
  0.16 * belonging +
  0.12 * mentoring_access +
  0.14 * recovery_capacity +
  0.14 * material_resources +
  0.12 * fairness +
  0.10 * psychological_safety
)

adaptive_persistence <- (
  0.24 * grit +
  0.26 * situational_support +
  0.14 * feedback_quality +
  0.12 * recovery_capacity +
  0.12 * belonging +
  0.10 * mentoring_access -
  0.18 * chronic_stress -
  0.14 * blocked_opportunity +
  0.12 * grit * situational_support +
  rnorm(n)
)

burnout_risk <- (
  0.28 * demand_intensity +
  0.20 * chronic_stress +
  0.16 * grit -
  0.24 * recovery_capacity -
  0.18 * autonomy_support -
  0.16 * psychological_safety -
  0.12 * fairness +
  rnorm(n)
)

goal_progress <- (
  0.22 * adaptive_persistence +
  0.18 * feedback_quality +
  0.16 * material_resources +
  0.14 * mentoring_access -
  0.12 * blocked_opportunity +
  rnorm(n)
)

wellbeing <- (
  0.20 * autonomy_support +
  0.20 * belonging +
  0.20 * recovery_capacity +
  0.14 * fairness -
  0.24 * burnout_risk -
  0.16 * chronic_stress +
  rnorm(n)
)

df <- data.frame(
  age,
  developmental_stage = factor(developmental_stage),
  perseverance_effort,
  consistency_interests,
  grit,
  autonomy_support,
  feedback_quality,
  belonging,
  mentoring_access,
  recovery_capacity,
  material_resources,
  fairness,
  psychological_safety,
  demand_intensity,
  chronic_stress,
  blocked_opportunity,
  situational_support,
  adaptive_persistence,
  burnout_risk,
  goal_progress,
  wellbeing
)

dir.create(file.path("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

write.csv(df, file.path("data", "processed", "situational-supports-modeled-data-r.csv"), row.names = FALSE)

stage_summary <- aggregate(
  cbind(
    grit,
    situational_support,
    adaptive_persistence,
    burnout_risk,
    goal_progress,
    wellbeing
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

model_grit_only <- lm(
  adaptive_persistence ~ grit + developmental_stage,
  data = df
)

model_support <- lm(
  adaptive_persistence ~ grit + situational_support + chronic_stress +
    blocked_opportunity + developmental_stage,
  data = df
)

model_interaction <- lm(
  adaptive_persistence ~ grit * situational_support + chronic_stress +
    blocked_opportunity + developmental_stage,
  data = df
)

model_burnout <- lm(
  burnout_risk ~ grit + demand_intensity + chronic_stress + recovery_capacity +
    autonomy_support + psychological_safety + fairness + developmental_stage,
  data = df
)

model_progress <- lm(
  goal_progress ~ adaptive_persistence + feedback_quality + material_resources +
    mentoring_access + blocked_opportunity + developmental_stage,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only_adaptive_persistence",
    "contextual_support_model",
    "grit_by_support_interaction_model",
    "burnout_safety_model",
    "goal_progress_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_support)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_burnout)$r.squared,
    summary(model_progress)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_support)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_burnout)$adj.r.squared,
    summary(model_progress)$adj.r.squared
  )
)

write.csv(stage_summary, file.path("outputs", "tables", "situational-supports-stage-summary-r.csv"), row.names = FALSE)
write.csv(comparison, file.path("outputs", "tables", "situational-supports-model-comparison-r.csv"), row.names = FALSE)
write.csv(summary(model_interaction)$coefficients, file.path("outputs", "tables", "situational-supports-interaction-coefficients-r.csv"))
write.csv(summary(model_burnout)$coefficients, file.path("outputs", "tables", "situational-supports-burnout-safety-coefficients-r.csv"))

print(round(stage_summary, 3))
print(round(comparison, 4))
cat("\nProfessional caution: synthetic situational-support modeling only.\n")
