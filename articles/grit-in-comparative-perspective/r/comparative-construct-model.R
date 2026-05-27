# Comparative construct model for Grit in Comparative Perspective.
# Synthetic data only. Not for individual assessment, hiring, admissions, ranking, diagnosis, or discipline.

set.seed(42)

n <- 1200

age <- sample(14:69, n, replace = TRUE)

developmental_stage <- ifelse(
  age < 18,
  "adolescence",
  ifelse(age < 30, "emerging_adulthood", ifelse(age < 55, "adulthood", "later_adulthood"))
)

self_control <- rnorm(n)
conscientiousness <- 0.40 * self_control + rnorm(n)
resilience_recovery <- rnorm(n)
deliberate_practice_quality <- rnorm(n)
motivation_quality <- rnorm(n)
purpose_alignment <- rnorm(n)
growth_mindset <- rnorm(n)
narrative_identity_flexibility <- rnorm(n)
environmental_support <- rnorm(n)
autonomy_support <- rnorm(n)
chronic_stress <- rnorm(n)
demand_intensity <- rnorm(n)

perseverance_effort <- (
  0.30 * conscientiousness +
  0.18 * self_control +
  0.20 * purpose_alignment +
  0.14 * environmental_support +
  rnorm(n)
)

consistency_interests <- (
  0.22 * conscientiousness +
  0.12 * self_control +
  0.28 * purpose_alignment +
  0.10 * environmental_support +
  rnorm(n)
)

grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

adaptive_persistence <- (
  0.22 * grit +
  0.14 * self_control +
  0.14 * conscientiousness +
  0.14 * resilience_recovery +
  0.16 * deliberate_practice_quality +
  0.14 * motivation_quality +
  0.16 * purpose_alignment +
  0.10 * growth_mindset +
  0.10 * narrative_identity_flexibility +
  0.18 * environmental_support -
  0.16 * chronic_stress +
  0.10 * grit * environmental_support +
  rnorm(n)
)

goal_progress <- (
  0.18 * adaptive_persistence +
  0.20 * deliberate_practice_quality +
  0.16 * environmental_support +
  0.14 * conscientiousness +
  0.12 * purpose_alignment -
  0.12 * chronic_stress +
  rnorm(n)
)

burnout_risk <- (
  0.28 * demand_intensity +
  0.18 * chronic_stress +
  0.14 * grit -
  0.22 * resilience_recovery -
  0.18 * autonomy_support -
  0.12 * environmental_support +
  rnorm(n)
)

wellbeing <- (
  0.22 * resilience_recovery +
  0.18 * purpose_alignment +
  0.16 * environmental_support +
  0.14 * autonomy_support -
  0.24 * burnout_risk -
  0.12 * chronic_stress +
  rnorm(n)
)

df <- data.frame(
  age,
  developmental_stage = factor(developmental_stage),
  self_control,
  conscientiousness,
  resilience_recovery,
  deliberate_practice_quality,
  motivation_quality,
  purpose_alignment,
  growth_mindset,
  narrative_identity_flexibility,
  environmental_support,
  autonomy_support,
  chronic_stress,
  demand_intensity,
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

write.csv(df, file.path("data", "processed", "grit-comparative-perspective-modeled-data-r.csv"), row.names = FALSE)

constructs <- c(
  "grit",
  "perseverance_effort",
  "consistency_interests",
  "self_control",
  "conscientiousness",
  "resilience_recovery",
  "deliberate_practice_quality",
  "motivation_quality",
  "purpose_alignment",
  "growth_mindset",
  "narrative_identity_flexibility",
  "environmental_support",
  "adaptive_persistence",
  "goal_progress",
  "burnout_risk",
  "wellbeing"
)

correlations <- cor(df[, constructs])
write.csv(correlations, file.path("outputs", "tables", "comparative-construct-correlation-matrix-r.csv"))

model_grit_only <- lm(
  adaptive_persistence ~ grit + developmental_stage,
  data = df
)

model_comparative <- lm(
  adaptive_persistence ~ grit + self_control + conscientiousness +
    resilience_recovery + deliberate_practice_quality + motivation_quality +
    purpose_alignment + growth_mindset + narrative_identity_flexibility +
    environmental_support + chronic_stress + developmental_stage,
  data = df
)

model_interaction <- lm(
  adaptive_persistence ~ grit * environmental_support + self_control +
    conscientiousness + resilience_recovery + deliberate_practice_quality +
    purpose_alignment + chronic_stress + developmental_stage,
  data = df
)

model_goal_progress <- lm(
  goal_progress ~ adaptive_persistence + grit + deliberate_practice_quality +
    environmental_support + conscientiousness + purpose_alignment + chronic_stress +
    developmental_stage,
  data = df
)

model_burnout <- lm(
  burnout_risk ~ grit + demand_intensity + chronic_stress + resilience_recovery +
    autonomy_support + environmental_support + developmental_stage,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only_adaptive_persistence",
    "comparative_construct_model",
    "grit_by_environment_support_model",
    "goal_progress_model",
    "burnout_safety_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_comparative)$r.squared,
    summary(model_interaction)$r.squared,
    summary(model_goal_progress)$r.squared,
    summary(model_burnout)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_comparative)$adj.r.squared,
    summary(model_interaction)$adj.r.squared,
    summary(model_goal_progress)$adj.r.squared,
    summary(model_burnout)$adj.r.squared
  )
)

write.csv(comparison, file.path("outputs", "tables", "comparative-construct-model-comparison-r.csv"), row.names = FALSE)
write.csv(summary(model_comparative)$coefficients, file.path("outputs", "tables", "comparative-construct-model-coefficients-r.csv"))
write.csv(summary(model_burnout)$coefficients, file.path("outputs", "tables", "comparative-construct-burnout-safety-coefficients-r.csv"))

print(round(comparison, 4))
cat("\nProfessional caution: synthetic comparative construct modeling only.\n")
