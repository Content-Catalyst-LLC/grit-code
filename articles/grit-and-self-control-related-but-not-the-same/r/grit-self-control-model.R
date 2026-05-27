# Grit and Self-Control: Related but Not the Same
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 900

attention_regulation <- rnorm(n)
emotion_regulation <- rnorm(n)
impulse_control <- rnorm(n)

self_control <- (
  0.40 * attention_regulation +
  0.30 * emotion_regulation +
  0.30 * impulse_control
)

perseverance_effort <- 0.35 * self_control + rnorm(n, sd = 0.90)
consistency_interests <- rnorm(n)

grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

conscientiousness <- 0.45 * self_control + 0.45 * perseverance_effort + rnorm(n, sd = 0.85)
social_support <- rnorm(n)
prior_achievement <- rnorm(n)
burnout <- rnorm(n)

daily_task_completion <- (
  0.42 * self_control +
  0.15 * grit +
  0.20 * conscientiousness +
  0.15 * social_support -
  0.25 * burnout +
  rnorm(n)
)

long_term_goal_progress <- (
  0.18 * self_control +
  0.34 * grit +
  0.24 * prior_achievement +
  0.18 * social_support -
  0.22 * burnout +
  rnorm(n)
)

df <- data.frame(
  attention_regulation,
  emotion_regulation,
  impulse_control,
  self_control,
  perseverance_effort,
  consistency_interests,
  grit,
  conscientiousness,
  social_support,
  prior_achievement,
  burnout,
  daily_task_completion,
  long_term_goal_progress
)

sc_median <- median(df$self_control)
grit_median <- median(df$grit)

df$profile <- ifelse(
  df$self_control >= sc_median & df$grit >= grit_median,
  "high_self_control_high_grit",
  ifelse(
    df$self_control >= sc_median & df$grit < grit_median,
    "high_self_control_low_grit",
    ifelse(
      df$self_control < sc_median & df$grit >= grit_median,
      "low_self_control_high_grit",
      "low_self_control_low_grit"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-self-control-modeled-data-r.csv", row.names = FALSE)

profile_summary <- aggregate(
  cbind(daily_task_completion, long_term_goal_progress, burnout, social_support, self_control, grit) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-self-control-profile-summary-r.csv", row.names = FALSE)

daily_self_control_model <- lm(daily_task_completion ~ self_control, data = df)
daily_grit_model <- lm(daily_task_completion ~ grit, data = df)
daily_combined_model <- lm(daily_task_completion ~ self_control + grit, data = df)
daily_contextual_model <- lm(
  daily_task_completion ~ self_control + grit + conscientiousness +
    social_support + burnout,
  data = df
)

long_term_contextual_model <- lm(
  long_term_goal_progress ~ self_control + grit + prior_achievement +
    social_support + burnout,
  data = df
)

comparison <- data.frame(
  model = c(
    "daily_self_control_only",
    "daily_grit_only",
    "daily_self_control_plus_grit",
    "daily_contextual",
    "long_term_contextual"
  ),
  outcome = c(
    "daily_task_completion",
    "daily_task_completion",
    "daily_task_completion",
    "daily_task_completion",
    "long_term_goal_progress"
  ),
  r_squared = c(
    summary(daily_self_control_model)$r.squared,
    summary(daily_grit_model)$r.squared,
    summary(daily_combined_model)$r.squared,
    summary(daily_contextual_model)$r.squared,
    summary(long_term_contextual_model)$r.squared
  ),
  adjusted_r_squared = c(
    summary(daily_self_control_model)$adj.r.squared,
    summary(daily_grit_model)$adj.r.squared,
    summary(daily_combined_model)$adj.r.squared,
    summary(daily_contextual_model)$adj.r.squared,
    summary(long_term_contextual_model)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-self-control-model-comparison-r.csv", row.names = FALSE)

print(round(profile_summary, 3))
print(round(comparison, 4))
