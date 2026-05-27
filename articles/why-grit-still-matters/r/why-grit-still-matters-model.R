# Adaptive-persistence model for Why Grit Still Matters.
# Synthetic data only. Not for individual assessment, hiring, admissions, ranking, diagnosis, or discipline.

set.seed(42)

n <- 1400

age <- sample(14:69, n, replace = TRUE)

developmental_stage <- ifelse(
  age < 18,
  "adolescence",
  ifelse(age < 30, "emerging_adulthood", ifelse(age < 55, "adulthood", "later_adulthood"))
)

self_control <- rnorm(n)
conscientiousness <- 0.40 * self_control + rnorm(n)
purpose_alignment <- rnorm(n)
feedback_quality <- rnorm(n)
recovery_capacity <- rnorm(n)
environmental_support <- rnorm(n)
autonomy_support <- rnorm(n)
social_support <- rnorm(n)
practice_quality <- rnorm(n)
demand_intensity <- rnorm(n)
chronic_stress <- rnorm(n)
blocked_opportunity <- rnorm(n)

perseverance_effort <- (
  0.28 * conscientiousness +
  0.18 * self_control +
  0.22 * purpose_alignment +
  0.12 * environmental_support +
  rnorm(n)
)

consistency_interests <- (
  0.22 * conscientiousness +
  0.12 * self_control +
  0.30 * purpose_alignment +
  0.10 * environmental_support +
  rnorm(n)
)

grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

adaptive_persistence <- (
  0.22 * grit +
  0.14 * self_control +
  0.14 * practice_quality +
  0.16 * purpose_alignment +
  0.16 * feedback_quality +
  0.16 * recovery_capacity +
  0.18 * environmental_support +
  0.12 * social_support -
  0.14 * chronic_stress -
  0.12 * blocked_opportunity +
  0.10 * grit * environmental_support +
  rnorm(n)
)

goal_progress <- (
  0.20 * adaptive_persistence +
  0.18 * practice_quality +
  0.16 * feedback_quality +
  0.14 * purpose_alignment +
  0.12 * environmental_support -
  0.12 * blocked_opportunity +
  rnorm(n)
)

burnout_risk <- (
  0.26 * demand_intensity +
  0.22 * chronic_stress +
  0.12 * grit -
  0.22 * recovery_capacity -
  0.16 * autonomy_support -
  0.14 * social_support -
  0.12 * environmental_support +
  rnorm(n)
)

wellbeing <- (
  0.18 * purpose_alignment +
  0.18 * recovery_capacity +
  0.16 * social_support +
  0.14 * autonomy_support +
  0.12 * environmental_support -
  0.24 * burnout_risk -
  0.12 * chronic_stress +
  rnorm(n)
)

df <- data.frame(
  age,
  developmental_stage = factor(developmental_stage),
  self_control,
  conscientiousness,
  purpose_alignment,
  feedback_quality,
  recovery_capacity,
  environmental_support,
  autonomy_support,
  social_support,
  practice_quality,
  demand_intensity,
  chronic_stress,
  blocked_opportunity,
  perseverance_effort,
  consistency_interests,
  grit,
  adaptive_persistence,
  goal_progress,
  burnout_risk,
  wellbeing
)

dir.create(file.path("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

write.csv(df, file.path("data", "processed", "why-grit-still-matters-modeled-data-r.csv"), row.names = FALSE)

stage_summary <- aggregate(
  cbind(
    grit,
    adaptive_persistence,
    goal_progress,
    burnout_risk,
    wellbeing,
    environmental_support
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

model_grit_only <- lm(
  adaptive_persistence ~ grit + developmental_stage,
  data = df
)

model_comparative <- lm(
  adaptive_persistence ~ grit + self_control + conscientiousness +
    purpose_alignment + feedback_quality + practice_quality + recovery_capacity +
    environmental_support + social_support + chronic_stress + blocked_opportunity +
    developmental_stage,
  data = df
)

model_interaction <- lm(
  adaptive_persistence ~ grit * environmental_support + self_control +
    purpose_alignment + feedback_quality + recovery_capacity + chronic_stress +
    blocked_opportunity + developmental_stage,
  data = df
)

model_progress <- lm(
  goal_progress ~ adaptive_persistence + grit + practice_quality + feedback_quality +
    purpose_alignment + environmental_support + blocked_opportunity + developmental_stage,
  data = df
)

model_burnout <- lm(
  burnout_risk ~ grit + demand_intensity + chronic_stress + recovery_capacity +
    autonomy_support + social_support + environmental_support + developmental_stage,
  data = df
)

model_wellbeing <- lm(
  wellbeing ~ grit + adaptive_persistence + purpose_alignment + recovery_capacity +
    social_support + autonomy_support + burnout_risk + chronic_stress + developmental_stage,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only_adaptive_persistence",
    "comparative_adaptive_persistence_model",
    "grit_by_environment_interaction_model",
    "goal_progress_model",
    "burnout_safety_model",
    "wellbeing_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_comparative)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_progress)$r.squared,
    summary(model_burnout)$r.squared,
    summary(model_wellbeing)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_comparative)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_progress)$adj.r.squared,
    summary(model_burnout)$adj.r.squared,
    summary(model_wellbeing)$adj.r.squared
  )
)

write.csv(stage_summary, file.path("outputs", "tables", "why-grit-still-matters-stage-summary-r.csv"), row.names = FALSE)
write.csv(comparison, file.path("outputs", "tables", "why-grit-still-matters-model-comparison-r.csv"), row.names = FALSE)
write.csv(summary(model_comparative)$coefficients, file.path("outputs", "tables", "why-grit-still-matters-comparative-model-coefficients-r.csv"))
write.csv(summary(model_burnout)$coefficients, file.path("outputs", "tables", "why-grit-still-matters-burnout-safety-coefficients-r.csv"))

print(round(stage_summary, 3))
print(round(comparison, 4))
cat("\nProfessional caution: synthetic adaptive-persistence modeling only.\n")
