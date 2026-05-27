# Environmental design model for grit-supportive systems.
# Synthetic data only. Not for individual assessment, hiring, admissions, ranking, diagnosis, or discipline.

set.seed(42)

n <- 1200

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
competence_support <- rnorm(n)
feedback_quality <- rnorm(n)
belonging <- rnorm(n)
mentoring_access <- rnorm(n)
recovery_design <- rnorm(n)
material_resources <- rnorm(n)
fairness <- rnorm(n)
psychological_safety <- rnorm(n)
adaptive_quitting_norms <- rnorm(n)

demand_intensity <- rnorm(n)
chronic_stress <- rnorm(n)
blocked_opportunity <- rnorm(n)

environment_design <- (
  0.13 * autonomy_support +
  0.13 * competence_support +
  0.13 * feedback_quality +
  0.12 * belonging +
  0.10 * mentoring_access +
  0.13 * recovery_design +
  0.10 * material_resources +
  0.11 * fairness +
  0.10 * psychological_safety +
  0.05 * adaptive_quitting_norms
)

adaptive_persistence <- (
  0.24 * grit +
  0.30 * environment_design +
  0.12 * feedback_quality +
  0.12 * recovery_design +
  0.10 * belonging +
  0.10 * fairness -
  0.18 * chronic_stress -
  0.14 * blocked_opportunity +
  0.12 * grit * environment_design +
  rnorm(n)
)

burnout_risk <- (
  0.28 * demand_intensity +
  0.22 * chronic_stress +
  0.14 * grit -
  0.24 * recovery_design -
  0.18 * autonomy_support -
  0.16 * psychological_safety -
  0.12 * fairness -
  0.10 * adaptive_quitting_norms +
  rnorm(n)
)

goal_progress <- (
  0.22 * adaptive_persistence +
  0.18 * feedback_quality +
  0.16 * competence_support +
  0.14 * material_resources +
  0.12 * mentoring_access -
  0.12 * blocked_opportunity +
  rnorm(n)
)

wellbeing <- (
  0.20 * autonomy_support +
  0.18 * belonging +
  0.18 * recovery_design +
  0.14 * fairness +
  0.12 * psychological_safety -
  0.24 * burnout_risk -
  0.14 * chronic_stress +
  rnorm(n)
)

df <- data.frame(
  age,
  developmental_stage = factor(developmental_stage),
  perseverance_effort,
  consistency_interests,
  grit,
  autonomy_support,
  competence_support,
  feedback_quality,
  belonging,
  mentoring_access,
  recovery_design,
  material_resources,
  fairness,
  psychological_safety,
  adaptive_quitting_norms,
  demand_intensity,
  chronic_stress,
  blocked_opportunity,
  environment_design,
  adaptive_persistence,
  burnout_risk,
  goal_progress,
  wellbeing
)

dir.create(file.path("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

write.csv(df, file.path("data", "processed", "environmental-design-modeled-data-r.csv"), row.names = FALSE)

stage_summary <- aggregate(
  cbind(
    grit,
    environment_design,
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

model_design <- lm(
  adaptive_persistence ~ grit + environment_design + chronic_stress +
    blocked_opportunity + developmental_stage,
  data = df
)

model_interaction <- lm(
  adaptive_persistence ~ grit * environment_design + chronic_stress +
    blocked_opportunity + developmental_stage,
  data = df
)

model_burnout <- lm(
  burnout_risk ~ grit + demand_intensity + chronic_stress + recovery_design +
    autonomy_support + psychological_safety + fairness + adaptive_quitting_norms +
    developmental_stage,
  data = df
)

model_progress <- lm(
  goal_progress ~ adaptive_persistence + feedback_quality + competence_support +
    material_resources + mentoring_access + blocked_opportunity + developmental_stage,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only_adaptive_persistence",
    "environment_design_model",
    "grit_by_environment_interaction_model",
    "burnout_safety_model",
    "goal_progress_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_design)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_burnout)$r.squared,
    summary(model_progress)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_design)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_burnout)$adj.r.squared,
    summary(model_progress)$adj.r.squared
  )
)

write.csv(stage_summary, file.path("outputs", "tables", "environmental-design-stage-summary-r.csv"), row.names = FALSE)
write.csv(comparison, file.path("outputs", "tables", "environmental-design-model-comparison-r.csv"), row.names = FALSE)
write.csv(summary(model_interaction)$coefficients, file.path("outputs", "tables", "environmental-design-interaction-coefficients-r.csv"))
write.csv(summary(model_burnout)$coefficients, file.path("outputs", "tables", "environmental-design-burnout-safety-coefficients-r.csv"))

print(round(stage_summary, 3))
print(round(comparison, 4))
cat("\nProfessional caution: synthetic environmental-design modeling only.\n")
