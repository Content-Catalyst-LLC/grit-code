# Psychometrics workflow for Why Grit Still Matters.
# Synthetic data only. Not a validated psychological instrument.

data_path <- file.path("data", "raw", "why-grit-still-matters-synthetic-survey.csv")
df <- read.csv(data_path)

df$grit_composite_calculated <- rowMeans(df[, c("perseverance_effort", "consistency_interests")])

constructs <- c(
  "grit_composite_calculated",
  "perseverance_effort",
  "consistency_interests",
  "self_control",
  "conscientiousness",
  "purpose_alignment",
  "feedback_quality",
  "practice_quality",
  "recovery_capacity",
  "environmental_support",
  "social_support",
  "autonomy_support",
  "chronic_stress",
  "blocked_opportunity",
  "adaptive_persistence",
  "goal_progress",
  "burnout_risk",
  "wellbeing"
)

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

correlations <- cor(df[, constructs])
write.csv(correlations, file.path("outputs", "tables", "why-grit-still-matters-correlation-matrix-r.csv"))

stage_summary <- aggregate(
  cbind(
    grit_composite_calculated,
    purpose_alignment,
    feedback_quality,
    recovery_capacity,
    environmental_support,
    adaptive_persistence,
    goal_progress,
    burnout_risk,
    wellbeing
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

write.csv(stage_summary, file.path("outputs", "tables", "why-grit-still-matters-stage-summary-r.csv"), row.names = FALSE)

print(round(correlations, 3))
print(round(stage_summary, 3))
cat("\nProfessional caution: synthetic data only; not a validated instrument.\n")
