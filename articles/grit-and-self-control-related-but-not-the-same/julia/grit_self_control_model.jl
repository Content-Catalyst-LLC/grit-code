# Grit and Self-Control: Related but Not the Same
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 900

attention_regulation = randn(n)
emotion_regulation = randn(n)
impulse_control = randn(n)

self_control =
    0.40 .* attention_regulation .+
    0.30 .* emotion_regulation .+
    0.30 .* impulse_control

perseverance_effort = 0.35 .* self_control .+ 0.90 .* randn(n)
consistency_interests = randn(n)

grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

conscientiousness = 0.45 .* self_control .+ 0.45 .* perseverance_effort .+ 0.85 .* randn(n)
social_support = randn(n)
prior_achievement = randn(n)
burnout = randn(n)

daily_task_completion =
    0.42 .* self_control .+
    0.15 .* grit .+
    0.20 .* conscientiousness .+
    0.15 .* social_support .-
    0.25 .* burnout .+
    randn(n)

long_term_goal_progress =
    0.18 .* self_control .+
    0.34 .* grit .+
    0.24 .* prior_achievement .+
    0.18 .* social_support .-
    0.22 .* burnout .+
    randn(n)

df = DataFrame(
    attention_regulation = attention_regulation,
    emotion_regulation = emotion_regulation,
    impulse_control = impulse_control,
    self_control = self_control,
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    conscientiousness = conscientiousness,
    social_support = social_support,
    prior_achievement = prior_achievement,
    burnout = burnout,
    daily_task_completion = daily_task_completion,
    long_term_goal_progress = long_term_goal_progress
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-self-control-modeled-data-julia.csv"), df)

println(describe(df))
