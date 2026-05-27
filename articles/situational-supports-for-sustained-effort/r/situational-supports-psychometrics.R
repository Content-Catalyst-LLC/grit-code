# Psychometrics workflow for Situational Supports for Sustained Effort.
# Synthetic data only. Not a validated psychological instrument.

data_path <- file.path("data", "raw", "situational-supports-synthetic-survey.csv")
df <- read.csv(data_path)

support_facets <- c(
  "autonomy_support",
  "feedback_quality",
  "belonging",
  "mentoring_access",
  "recovery_capacity",
  "material_resources",
  "fairness",
  "psychological_safety"
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

df$situational_support_composite <- rowMeans(df[, support_facets])

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

reliability <- data.frame(
  scale = "situational_support_composite",
  n_items = length(support_facets),
  cronbach_alpha_demo = cronbach_alpha(df[, support_facets])
)

write.csv(reliability, file.path("outputs", "tables", "situational-supports-reliability-demo-r.csv"), row.names = FALSE)

correlation_variables <- c(
  "grit_composite",
  "situational_support_composite",
  "autonomy_support",
  "feedback_quality",
  "belonging",
  "recovery_capacity",
  "material_resources",
  "fairness",
  "psychological_safety",
  "chronic_stress",
  "blocked_opportunity",
  "adaptive_persistence",
  "burnout_risk",
  "goal_progress",
  "wellbeing"
)

correlations <- cor(df[, correlation_variables])
write.csv(correlations, file.path("outputs", "tables", "situational-supports-contextual-validity-correlations-r.csv"))

stage_summary <- aggregate(
  cbind(
    grit_composite,
    situational_support_composite,
    adaptive_persistence,
    burnout_risk,
    goal_progress,
    wellbeing
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

write.csv(stage_summary, file.path("outputs", "tables", "situational-supports-stage-summary-r.csv"), row.names = FALSE)

print(round(reliability, 3))
print(round(stage_summary, 3))
cat("\nProfessional caution: synthetic data only; not a validated instrument.\n")
