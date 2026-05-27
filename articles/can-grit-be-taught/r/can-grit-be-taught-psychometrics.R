# Psychometrics workflow for "Can Grit Be Taught?"
# Synthetic data only. Not a validated psychological instrument.

data_path <- file.path("data", "raw", "can-grit-be-taught-synthetic-intervention-survey.csv")
df <- read.csv(data_path)

df$baseline_grit_composite <- rowMeans(df[, c("baseline_perseverance", "baseline_consistency")])
df$post_grit_composite <- rowMeans(df[, c("post_perseverance", "post_consistency")])
df$grit_change <- df$post_grit_composite - df$baseline_grit_composite
df$adaptive_persistence_change <- df$post_adaptive_persistence - df$baseline_adaptive_persistence
df$burnout_risk_change <- df$post_burnout_risk - df$baseline_burnout_risk

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

summary_by_condition <- aggregate(
  cbind(
    baseline_grit_composite,
    post_grit_composite,
    grit_change,
    adaptive_persistence_change,
    burnout_risk_change,
    post_wellbeing,
    intervention_acceptability
  ) ~ condition,
  data = df,
  FUN = mean
)

write.csv(
  summary_by_condition,
  file.path("outputs", "tables", "can-grit-be-taught-summary-by-condition-r.csv"),
  row.names = FALSE
)

correlation_variables <- c(
  "baseline_grit_composite",
  "post_grit_composite",
  "grit_change",
  "post_purpose_alignment",
  "post_feedback_responsiveness",
  "post_recovery_capacity",
  "post_burnout_risk",
  "post_wellbeing",
  "goal_progress",
  "intervention_acceptability"
)

correlations <- cor(df[, correlation_variables])
write.csv(
  correlations,
  file.path("outputs", "tables", "can-grit-be-taught-validity-correlations-r.csv")
)

print(round(summary_by_condition, 3))
print(round(correlations, 3))
cat("\nProfessional caution: synthetic data only; not a validated psychological instrument.\n")
