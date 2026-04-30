# Synthetic grit analysis.
# Run after the Python script creates data/processed/synthetic_grit_observations.csv.

data_path <- file.path("data", "processed", "synthetic_grit_observations.csv")

if (!file.exists(data_path)) {
  stop("Run: python3 python/grit_simulation.py")
}

dat <- read.csv(data_path)

summary_table <- aggregate(
  cbind(weekly_progress, cumulative_progress, perseverance, interest_consistency,
        recovery_capacity, self_control_support, meaning_alignment, support_index,
        friction_load, burnout_risk, adaptive_disengagement_signal) ~ wave,
  data = dat,
  FUN = mean
)

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)
write.csv(summary_table, file.path("outputs", "grit_wave_summary.csv"), row.names = FALSE)

model <- lm(
  weekly_progress ~ perseverance + interest_consistency + recovery_capacity +
    self_control_support + meaning_alignment + support_index -
    friction_load - burnout_risk,
  data = dat
)

print(summary(model))
print(summary_table)
