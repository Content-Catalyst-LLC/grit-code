# Longitudinal/developmental model workflow for positive psychology.
# Synthetic data only. Not for individual assessment.

set.seed(42)

rows <- list()
row_id <- 1

for (participant_id in 1:200) {
  baseline_age <- sample(c(14, 18, 30, 55), 1)
  stable_support <- rnorm(1, 0, 0.6)
  stable_stress <- rnorm(1, 0, 0.6)
  prior_grit <- rnorm(1, 0, 0.5)

  for (wave in 0:3) {
    age <- baseline_age + wave
    stage <- ifelse(
      age < 18,
      "adolescence",
      ifelse(age < 30, "emerging_adulthood", ifelse(age < 55, "adulthood", "later_adulthood"))
    )

    support <- stable_support + rnorm(1, 0, 0.4)
    feedback <- rnorm(1)
    purpose <- rnorm(1) + 0.15 * wave
    recovery <- support + rnorm(1, 0, 0.5)
    stress <- stable_stress + rnorm(1, 0, 0.4)

    grit <- (
      0.50 * prior_grit +
      0.20 * support +
      0.18 * feedback +
      0.22 * purpose +
      0.16 * recovery -
      0.18 * stress +
      rnorm(1, 0, 0.7)
    )

    wellbeing <- 0.25 * purpose + 0.22 * support + 0.20 * recovery - 0.28 * stress + rnorm(1, 0, 0.8)
    adaptive_persistence <- 0.30 * grit + 0.18 * feedback + 0.20 * recovery + 0.18 * support - 0.16 * stress + rnorm(1, 0, 0.8)

    rows[[row_id]] <- data.frame(
      participant_id = participant_id,
      wave = wave,
      age = age,
      developmental_stage = stage,
      support = support,
      feedback_quality = feedback,
      purpose_alignment = purpose,
      recovery_capacity = recovery,
      chronic_stress = stress,
      grit_latent_demo = grit,
      wellbeing = wellbeing,
      adaptive_persistence = adaptive_persistence
    )

    prior_grit <- grit
    row_id <- row_id + 1
  }
}

df <- do.call(rbind, rows)

dir.create(file.path("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path("outputs", "tables"), recursive = TRUE, showWarnings = FALSE)

write.csv(df, file.path("data", "processed", "synthetic-longitudinal-grit-development-r.csv"), row.names = FALSE)

stage_wave <- aggregate(
  cbind(grit_latent_demo, wellbeing, adaptive_persistence, support, recovery_capacity, chronic_stress) ~ developmental_stage + wave,
  data = df,
  FUN = mean
)

write.csv(stage_wave, file.path("outputs", "tables", "longitudinal-stage-wave-summary-demo-r.csv"), row.names = FALSE)

model <- lm(
  adaptive_persistence ~ grit_latent_demo + support + feedback_quality +
    purpose_alignment + recovery_capacity + chronic_stress + developmental_stage,
  data = df
)

write.csv(summary(model)$coefficients, file.path("outputs", "tables", "longitudinal-adaptive-persistence-model-r.csv"))

print(round(head(stage_wave, 20), 3))
print(round(summary(model)$coefficients, 4))
cat("\nProfessional caution: synthetic longitudinal demonstration only.\n")
