# Grit and Conscientiousness: Overlap, Distinction, and Debate
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 900

industriousness <- rnorm(n)
orderliness <- rnorm(n)
dependability <- rnorm(n)
responsibility <- rnorm(n)
achievement_striving <- rnorm(n)

conscientiousness <- (
  0.30 * industriousness +
  0.18 * orderliness +
  0.18 * dependability +
  0.17 * responsibility +
  0.17 * achievement_striving
)

perseverance_effort <- (
  0.55 * industriousness +
  0.25 * achievement_striving +
  rnorm(n, sd = 0.85)
)

consistency_interests <- (
  0.20 * achievement_striving +
  rnorm(n, sd = 1.00)
)

grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

prior_achievement <- rnorm(n)
social_support <- rnorm(n)
burnout <- rnorm(n)

long_term_progress <- (
  0.24 * conscientiousness +
  0.18 * grit +
  0.22 * prior_achievement +
  0.18 * social_support -
  0.20 * burnout +
  rnorm(n)
)

df <- data.frame(
  industriousness,
  orderliness,
  dependability,
  responsibility,
  achievement_striving,
  conscientiousness,
  perseverance_effort,
  consistency_interests,
  grit,
  prior_achievement,
  social_support,
  burnout,
  long_term_progress
)

c_median <- median(df$conscientiousness)
g_median <- median(df$grit)

df$profile <- ifelse(
  df$conscientiousness >= c_median & df$grit >= g_median,
  "high_conscientiousness_high_grit",
  ifelse(
    df$conscientiousness >= c_median & df$grit < g_median,
    "high_conscientiousness_low_grit",
    ifelse(
      df$conscientiousness < c_median & df$grit >= g_median,
      "low_conscientiousness_high_grit",
      "low_conscientiousness_low_grit"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-conscientiousness-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "conscientiousness",
  "grit",
  "perseverance_effort",
  "consistency_interests",
  "industriousness",
  "achievement_striving",
  "long_term_progress"
)])

write.csv(correlations, "outputs/tables/grit-conscientiousness-correlations-r.csv")

profile_summary <- aggregate(
  cbind(
    long_term_progress,
    conscientiousness,
    grit,
    perseverance_effort,
    consistency_interests,
    burnout,
    social_support
  ) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-conscientiousness-profile-summary-r.csv", row.names = FALSE)

model_conscientiousness <- lm(long_term_progress ~ conscientiousness, data = df)
model_grit <- lm(long_term_progress ~ grit, data = df)
model_combined <- lm(long_term_progress ~ conscientiousness + grit, data = df)

model_facets <- lm(
  long_term_progress ~ conscientiousness +
    perseverance_effort + consistency_interests,
  data = df
)

model_contextual <- lm(
  long_term_progress ~ conscientiousness +
    perseverance_effort + consistency_interests +
    prior_achievement + social_support + burnout,
  data = df
)

comparison <- data.frame(
  model = c(
    "conscientiousness_only",
    "grit_only",
    "conscientiousness_plus_grit",
    "conscientiousness_plus_grit_facets",
    "contextual_model"
  ),
  r_squared = c(
    summary(model_conscientiousness)$r.squared,
    summary(model_grit)$r.squared,
    summary(model_combined)$r.squared,
    summary(model_facets)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_conscientiousness)$adj.r.squared,
    summary(model_grit)$adj.r.squared,
    summary(model_combined)$adj.r.squared,
    summary(model_facets)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-conscientiousness-model-comparison-r.csv", row.names = FALSE)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
