# Psychometrics workflow for Grit in Comparative Perspective.
# Synthetic data only. Not a validated psychological instrument.

data_path <- file.path("data", "raw", "grit-comparative-perspective-synthetic-survey.csv")
df <- read.csv(data_path)

df$grit_composite_calculated <- rowMeans(df[, c("perseverance_effort", "consistency_interests")])

constructs <- c(
  "grit_composite_calculated",
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

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

correlations <- cor(df[, constructs])
write.csv(correlations, file.path("outputs", "tables", "comparative-construct-correlation-matrix-r.csv"))

stage_summary <- aggregate(
  cbind(
    grit_composite_calculated,
    self_control,
    conscientiousness,
    resilience_recovery,
    deliberate_practice_quality,
    purpose_alignment,
    environmental_support,
    adaptive_persistence,
    burnout_risk,
    wellbeing
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

write.csv(stage_summary, file.path("outputs", "tables", "comparative-construct-stage-summary-r.csv"), row.names = FALSE)

print(round(correlations, 3))
print(round(stage_summary, 3))
cat("\nProfessional caution: synthetic data only; not a validated instrument.\n")
