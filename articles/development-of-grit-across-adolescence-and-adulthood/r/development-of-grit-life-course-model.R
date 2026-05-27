# The Development of Grit Across Adolescence and Adulthood
# Synthetic-data workflow for article support only.

set.seed(42)

n <- 500

df <- data.frame(
  age = sample(c(12, 14, 16, 18, 22, 30, 40, 55, 65), n, replace = TRUE),
  support = rnorm(n),
  feedback_quality = rnorm(n),
  purpose = rnorm(n),
  recovery_capacity = rnorm(n),
  chronic_stress = rnorm(n),
  opportunity_access = rnorm(n)
)

df$stage <- ifelse(
  df$age < 18,
  "adolescence",
  ifelse(df$age < 30, "emerging_adulthood", ifelse(df$age < 55, "adulthood", "later_adulthood"))
)

df$perseverance_effort <- (
  0.18 * df$support +
  0.18 * df$feedback_quality +
  0.20 * df$purpose +
  0.15 * df$recovery_capacity +
  0.12 * df$opportunity_access -
  0.18 * df$chronic_stress +
  rnorm(n)
)

df$consistency_interests <- (
  0.22 * df$purpose +
  0.12 * df$opportunity_access +
  0.10 * df$support -
  0.10 * df$chronic_stress +
  rnorm(n)
)

df$grit <- 0.60 * df$perseverance_effort + 0.40 * df$consistency_interests

df$adaptive_persistence <- (
  0.24 * df$grit +
  0.20 * df$support +
  0.18 * df$feedback_quality +
  0.20 * df$purpose +
  0.16 * df$recovery_capacity +
  0.16 * df$opportunity_access -
  0.20 * df$chronic_stress +
  rnorm(n)
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/development-of-grit-life-course-modeled-data-r.csv", row.names = FALSE)

stage_summary <- aggregate(
  cbind(grit, perseverance_effort, consistency_interests, adaptive_persistence, support, purpose, chronic_stress) ~ stage,
  data = df,
  FUN = mean
)

write.csv(stage_summary, "outputs/tables/development-of-grit-stage-summary-r.csv", row.names = FALSE)

model <- lm(
  grit ~ age + I(age^2) + support + feedback_quality + purpose +
    recovery_capacity + opportunity_access - chronic_stress + stage,
  data = df
)

write.csv(summary(model)$coefficients, "outputs/tables/development-of-grit-model-coefficients-r.csv")

print(round(stage_summary, 3))
print(round(summary(model)$coefficients, 4))
