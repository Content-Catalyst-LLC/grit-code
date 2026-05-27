# Grit, Motivation, and Goal Hierarchies
# Synthetic-data workflow for research-method demonstration only.
# Do not use this workflow to evaluate, rank, hire, discipline, or assess real people.

set.seed(42)

n <- 900

perseverance_effort <- rnorm(n)
consistency_interests <- rnorm(n)
grit <- 0.60 * perseverance_effort + 0.40 * consistency_interests

intrinsic_interest <- rnorm(n)
identified_value <- rnorm(n)
purpose_orientation <- rnorm(n)
extrinsic_pressure <- rnorm(n)

motivation <- (
  0.30 * intrinsic_interest +
  0.30 * identified_value +
  0.30 * purpose_orientation +
  0.10 * extrinsic_pressure
)

superordinate_clarity <- rnorm(n)
midlevel_planning <- rnorm(n)
daily_action_alignment <- rnorm(n)

goal_hierarchy_coherence <- (
  0.35 * superordinate_clarity +
  0.30 * midlevel_planning +
  0.35 * daily_action_alignment
)

social_support <- rnorm(n)
feedback_quality <- rnorm(n)

burnout <- (
  0.20 * grit +
  0.15 * extrinsic_pressure -
  0.25 * social_support -
  0.20 * goal_hierarchy_coherence +
  rnorm(n)
)

long_term_progress <- (
  0.20 * grit +
  0.24 * motivation +
  0.30 * goal_hierarchy_coherence +
  0.18 * social_support +
  0.16 * feedback_quality -
  0.20 * burnout +
  rnorm(n)
)

df <- data.frame(
  perseverance_effort,
  consistency_interests,
  grit,
  intrinsic_interest,
  identified_value,
  purpose_orientation,
  extrinsic_pressure,
  motivation,
  superordinate_clarity,
  midlevel_planning,
  daily_action_alignment,
  goal_hierarchy_coherence,
  social_support,
  feedback_quality,
  burnout,
  long_term_progress
)

grit_median <- median(df$grit)
hierarchy_median <- median(df$goal_hierarchy_coherence)

df$profile <- ifelse(
  df$grit >= grit_median & df$goal_hierarchy_coherence >= hierarchy_median,
  "high_grit_high_hierarchy_coherence",
  ifelse(
    df$grit >= grit_median & df$goal_hierarchy_coherence < hierarchy_median,
    "high_grit_low_hierarchy_coherence",
    ifelse(
      df$grit < grit_median & df$goal_hierarchy_coherence >= hierarchy_median,
      "low_grit_high_hierarchy_coherence",
      "low_grit_low_hierarchy_coherence"
    )
  )
)

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(df, "data/processed/grit-motivation-goal-hierarchy-modeled-data-r.csv", row.names = FALSE)

correlations <- cor(df[, c(
  "grit",
  "motivation",
  "goal_hierarchy_coherence",
  "social_support",
  "feedback_quality",
  "burnout",
  "long_term_progress"
)])

write.csv(correlations, "outputs/tables/grit-motivation-goal-hierarchy-correlations-r.csv")

profile_summary <- aggregate(
  cbind(long_term_progress, grit, motivation, goal_hierarchy_coherence, burnout, social_support) ~ profile,
  data = df,
  FUN = mean
)

write.csv(profile_summary, "outputs/tables/grit-motivation-goal-hierarchy-profile-summary-r.csv", row.names = FALSE)

model_grit_only <- lm(long_term_progress ~ grit, data = df)

model_hierarchy <- lm(
  long_term_progress ~ grit + motivation + goal_hierarchy_coherence,
  data = df
)

model_contextual <- lm(
  long_term_progress ~ grit + motivation + goal_hierarchy_coherence +
    social_support + feedback_quality + burnout,
  data = df
)

comparison <- data.frame(
  model = c("grit_only", "grit_motivation_hierarchy", "contextual_model"),
  r_squared = c(
    summary(model_grit_only)$r.squared,
    summary(model_hierarchy)$r.squared,
    summary(model_contextual)$r.squared
  ),
  adjusted_r_squared = c(
    summary(model_grit_only)$adj.r.squared,
    summary(model_hierarchy)$adj.r.squared,
    summary(model_contextual)$adj.r.squared
  )
)

write.csv(comparison, "outputs/tables/grit-motivation-goal-hierarchy-model-comparison-r.csv", row.names = FALSE)
write.csv(
  summary(model_contextual)$coefficients,
  "outputs/tables/grit-motivation-goal-hierarchy-contextual-coefficients-r.csv"
)

print(round(correlations, 3))
print(round(profile_summary, 3))
print(round(comparison, 4))
print(round(summary(model_contextual)$coefficients, 4))
