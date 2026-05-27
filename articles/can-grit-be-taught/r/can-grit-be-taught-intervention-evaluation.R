# Intervention evaluation workflow for "Can Grit Be Taught?"
# Synthetic data only. Not for individual assessment, hiring, admissions, ranking, diagnosis, or discipline.

set.seed(42)

n <- 800
age <- sample(14:64, n, replace = TRUE)

developmental_stage <- ifelse(
  age < 18,
  "adolescence",
  ifelse(age < 30, "emerging_adulthood", ifelse(age < 55, "adulthood", "later_adulthood"))
)

baseline_support <- rnorm(n)
baseline_stress <- rnorm(n)
baseline_recovery <- 0.35 * baseline_support - 0.25 * baseline_stress + rnorm(n)
baseline_grit <- 0.30 * baseline_support + 0.25 * baseline_recovery - 0.20 * baseline_stress + rnorm(n)
baseline_burnout <- 0.35 * baseline_stress - 0.30 * baseline_recovery - 0.20 * baseline_support + rnorm(n)

treatment <- rbinom(n, 1, 0.5)
implementation_quality <- rnorm(n)

post_feedback_responsiveness <- (
  0.40 * treatment +
  0.25 * implementation_quality +
  0.20 * baseline_support +
  rnorm(n)
)

post_purpose_alignment <- (
  0.28 * treatment +
  0.25 * baseline_grit +
  0.20 * baseline_support +
  rnorm(n)
)

post_recovery_capacity <- (
  0.18 * treatment +
  0.45 * baseline_recovery +
  0.20 * baseline_support -
  0.20 * baseline_stress +
  rnorm(n)
)

post_grit <- (
  0.55 * baseline_grit +
  0.18 * treatment +
  0.18 * treatment * baseline_support +
  0.20 * post_feedback_responsiveness +
  0.20 * post_purpose_alignment +
  0.16 * post_recovery_capacity -
  0.16 * baseline_stress +
  rnorm(n)
)

adaptive_persistence <- (
  0.30 * post_grit +
  0.22 * post_feedback_responsiveness +
  0.20 * post_purpose_alignment +
  0.18 * post_recovery_capacity +
  0.18 * baseline_support -
  0.18 * baseline_stress +
  rnorm(n)
)

post_burnout <- (
  0.55 * baseline_burnout +
  0.24 * baseline_stress -
  0.24 * post_recovery_capacity -
  0.16 * baseline_support +
  0.06 * treatment +
  rnorm(n)
)

df <- data.frame(
  age,
  developmental_stage = factor(developmental_stage),
  baseline_support,
  baseline_stress,
  baseline_recovery,
  baseline_grit,
  baseline_burnout,
  treatment,
  implementation_quality,
  post_feedback_responsiveness,
  post_purpose_alignment,
  post_recovery_capacity,
  post_grit,
  adaptive_persistence,
  post_burnout
)

dir.create(file.path("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

write.csv(
  df,
  file.path("data", "processed", "can-grit-be-taught-synthetic-intervention-evaluation-r.csv"),
  row.names = FALSE
)

descriptive <- aggregate(
  cbind(
    baseline_grit,
    post_grit,
    adaptive_persistence,
    baseline_burnout,
    post_burnout,
    post_recovery_capacity
  ) ~ treatment,
  data = df,
  FUN = mean
)

model_post_grit <- lm(
  post_grit ~ treatment + baseline_grit + baseline_support +
    baseline_stress + developmental_stage,
  data = df
)

model_moderation <- lm(
  post_grit ~ treatment * baseline_support + baseline_grit +
    baseline_stress + developmental_stage,
  data = df
)

model_adaptive <- lm(
  adaptive_persistence ~ treatment + post_grit + post_feedback_responsiveness +
    post_purpose_alignment + post_recovery_capacity + baseline_support +
    baseline_stress + developmental_stage,
  data = df
)

model_burnout <- lm(
  post_burnout ~ treatment + baseline_burnout + baseline_stress +
    post_recovery_capacity + baseline_support + developmental_stage,
  data = df
)

comparison <- data.frame(
  model = c(
    "post_grit_intervention_effect",
    "support_moderation_model",
    "adaptive_persistence_model",
    "burnout_safety_model"
  ),
  r_squared = c(
    summary(model_post_grit)$r.squared,
    summary(model_moderation)$r.squared,
    summary(model_adaptive)$r.squared,
    summary(model_burnout)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_post_grit)$adj.r.squared,
    summary(model_moderation)$adj.r.squared,
    summary(model_adaptive)$adj.r.squared,
    summary(model_burnout)$adj.r.squared
  )
)

write.csv(descriptive, file.path("outputs", "tables", "can-grit-be-taught-descriptive-by-treatment-r.csv"), row.names = FALSE)
write.csv(comparison, file.path("outputs", "tables", "can-grit-be-taught-model-comparison-r.csv"), row.names = FALSE)
write.csv(summary(model_moderation)$coefficients, file.path("outputs", "tables", "can-grit-be-taught-support-moderation-coefficients-r.csv"))
write.csv(summary(model_burnout)$coefficients, file.path("outputs", "tables", "can-grit-be-taught-burnout-safety-coefficients-r.csv"))

print(round(descriptive, 3))
print(round(comparison, 4))
cat("\nProfessional caution: synthetic intervention evaluation only.\n")
