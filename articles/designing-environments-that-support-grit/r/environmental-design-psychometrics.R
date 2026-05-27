# Psychometrics workflow for Designing Environments That Support Grit.
# Synthetic data only. Not a validated psychological instrument.

data_path <- file.path("data", "raw", "designing-environments-that-support-grit-synthetic-survey.csv")
df <- read.csv(data_path)

design_facets <- c(
  "autonomy_support",
  "competence_support",
  "feedback_quality",
  "belonging",
  "mentoring_access",
  "recovery_design",
  "material_resources",
  "fairness",
  "psychological_safety",
  "adaptive_quitting_norms"
)

cronbach_alpha <- function(x) {
  x <- as.data.frame(x)
  item_variances <- apply(x, 2, var)
  total_score <- rowSums(x)
  n_items <- ncol(x)
  total_variance <- var(total_score)
  if (n_items <= 1 || total_variance == 0) return(NA_real_)
  (n_items / (n_items - 1)) * (1 - sum(item_variances) / total_variance)
}

df$environment_design_composite_calculated <- rowMeans(df[, design_facets])

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

reliability <- data.frame(
  scale = "environment_design_composite",
  n_items = length(design_facets),
  cronbach_alpha_demo = cronbach_alpha(df[, design_facets])
)

write.csv(reliability, file.path("outputs", "tables", "environmental-design-reliability-demo-r.csv"), row.names = FALSE)

correlation_variables <- c(
  "grit_composite",
  "environment_design_composite_calculated",
  "autonomy_support",
  "competence_support",
  "feedback_quality",
  "belonging",
  "recovery_design",
  "fairness",
  "psychological_safety",
  "adaptive_quitting_norms",
  "chronic_stress",
  "blocked_opportunity",
  "adaptive_persistence",
  "burnout_risk",
  "goal_progress",
  "wellbeing"
)

correlations <- cor(df[, correlation_variables])
write.csv(correlations, file.path("outputs", "tables", "environmental-design-contextual-validity-correlations-r.csv"))

stage_summary <- aggregate(
  cbind(
    grit_composite,
    environment_design_composite_calculated,
    adaptive_persistence,
    burnout_risk,
    goal_progress,
    wellbeing
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

write.csv(stage_summary, file.path("outputs", "tables", "environmental-design-stage-summary-r.csv"), row.names = FALSE)

print(round(reliability, 3))
print(round(stage_summary, 3))
cat("\nProfessional caution: synthetic data only; not a validated instrument.\n")
