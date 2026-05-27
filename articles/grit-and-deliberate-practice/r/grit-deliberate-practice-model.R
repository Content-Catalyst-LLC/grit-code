# Grit and Deliberate Practice
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 900

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

feedback_quality <- rnorm(n)
coaching_access <- rnorm(n)
prior_skill <- rnorm(n)
social_support <- rnorm(n)

deliberate_practice <- (
  0.35 * grit +
  0.28 * feedback_quality +
  0.22 * coaching_access +
  0.15 * social_support +
  rnorm(n)
)

burnout <- (
  0.20 * deliberate_practice -
  0.25 * social_support -
  0.20 * feedback_quality +
  rnorm(n)
)

performance <- (
  0.16 * grit +
  0.34 * deliberate_practice +
  0.28 * prior_skill +
  0.18 * feedback_quality +
  0.16 * coaching_access +
  0.14 * social_support -
  0.18 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  feedback_quality,
  coaching_access,
  prior_skill,
  social_support,
  deliberate_practice,
  burnout,
  performance
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-deliberate-practice-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "deliberate_practice",
  "feedback_quality",
  "coaching_access",
  "prior_skill",
  "social_support",
  "burnout",
  "performance"
)])

write.csv(correlations, "outputs/tables/grit-deliberate-practice-correlations-r.csv")

# Path A: grit predicting deliberate practice
model_practice <- lm(
  deliberate_practice ~ grit + feedback_quality + coaching_access + social_support,
  data = df
)

model_grit_only <- lm(performance ~ grit, data = df)
model_practice_only <- lm(performance ~ deliberate_practice, data = df)
model_grit_practice <- lm(performance ~ grit + deliberate_practice, data = df)

model_contextual <- lm(
  performance ~ grit + deliberate_practice + prior_skill +
    feedback_quality + coaching_access + social_support + burnout,
  data = df
)

comparison <- data.frame(
  model = c(
    "grit_only",
    "deliberate_practice_only",
    "grit_plus_deliberate_practice",
    "contextual_model"
  ),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_practice_only)$r.squared,
    summary(model_grit_practice)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_practice_only)$adj.r.squared,
    summary(model_grit_practice)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-deliberate-practice-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_practice)$coefficients,
  "outputs/tables/grit-deliberate-practice-practice-path-r.csv"
)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-deliberate-practice-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(summary(model_practice)$coefficients, 4))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
