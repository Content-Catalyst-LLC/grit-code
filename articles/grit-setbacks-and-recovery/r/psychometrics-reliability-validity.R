# Psychometrics workflow for a professional positive psychology research scaffold.
# Synthetic data only. Not a validated psychological instrument.

data_path <- file.path("data", "raw", "synthetic-positive-psychology-survey.csv")
df <- read.csv(data_path)

perseverance_items <- c(
  "perseverance_item_1",
  "perseverance_item_2",
  "perseverance_item_3",
  "perseverance_item_4"
)

consistency_items <- c(
  "consistency_item_1",
  "consistency_item_2",
  "consistency_item_3",
  "consistency_item_4"
)

all_items <- c(perseverance_items, consistency_items)

cronbach_alpha <- function(x) {
  x <- as.data.frame(x)
  item_variances <- apply(x, 2, var)
  total_score <- rowSums(x)
  n_items <- ncol(x)
  total_variance <- var(total_score)
  if (n_items <= 1 || total_variance == 0) return(NA_real_)
  (n_items / (n_items - 1)) * (1 - sum(item_variances) / total_variance)
}

df$perseverance_score <- rowMeans(df[, perseverance_items])
df$consistency_score <- rowMeans(df[, consistency_items])
df$grit_composite <- rowMeans(df[, all_items])

reliability <- data.frame(
  scale = c("perseverance_of_effort", "consistency_of_interests", "grit_composite"),
  n_items = c(length(perseverance_items), length(consistency_items), length(all_items)),
  cronbach_alpha_demo = c(
    cronbach_alpha(df[, perseverance_items]),
    cronbach_alpha(df[, consistency_items]),
    cronbach_alpha(df[, all_items])
  )
)

dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

write.csv(reliability, file.path("outputs", "tables", "psychometrics-reliability-demo-r.csv"), row.names = FALSE)

validity_variables <- c(
  "perseverance_score",
  "consistency_score",
  "grit_composite",
  "purpose_alignment",
  "feedback_responsiveness",
  "recovery_capacity",
  "social_support",
  "burnout_risk",
  "adaptive_persistence",
  "wellbeing",
  "goal_progress"
)

correlations <- cor(df[, validity_variables])
write.csv(correlations, file.path("outputs", "tables", "psychometrics-validity-correlation-demo-r.csv"))

stage_summary <- aggregate(
  cbind(
    grit_composite,
    perseverance_score,
    consistency_score,
    purpose_alignment,
    recovery_capacity,
    burnout_risk,
    wellbeing
  ) ~ developmental_stage,
  data = df,
  FUN = mean
)

write.csv(stage_summary, file.path("outputs", "tables", "psychometrics-stage-summary-demo-r.csv"), row.names = FALSE)

print(round(reliability, 3))
print(round(stage_summary, 3))
cat("\nProfessional caution: synthetic data only; not a validated instrument.\n")
