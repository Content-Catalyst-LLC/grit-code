# Grit, Motivation, and Goal Hierarchies
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 900

perseverance_effort = randn(n)
consistency_interests = randn(n)
grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

intrinsic_interest = randn(n)
identified_value = randn(n)
purpose_orientation = randn(n)
extrinsic_pressure = randn(n)

motivation =
    0.30 .* intrinsic_interest .+
    0.30 .* identified_value .+
    0.30 .* purpose_orientation .+
    0.10 .* extrinsic_pressure

superordinate_clarity = randn(n)
midlevel_planning = randn(n)
daily_action_alignment = randn(n)

goal_hierarchy_coherence =
    0.35 .* superordinate_clarity .+
    0.30 .* midlevel_planning .+
    0.35 .* daily_action_alignment

social_support = randn(n)
feedback_quality = randn(n)

burnout =
    0.20 .* grit .+
    0.15 .* extrinsic_pressure .-
    0.25 .* social_support .-
    0.20 .* goal_hierarchy_coherence .+
    randn(n)

long_term_progress =
    0.20 .* grit .+
    0.24 .* motivation .+
    0.30 .* goal_hierarchy_coherence .+
    0.18 .* social_support .+
    0.16 .* feedback_quality .-
    0.20 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    intrinsic_interest = intrinsic_interest,
    identified_value = identified_value,
    purpose_orientation = purpose_orientation,
    extrinsic_pressure = extrinsic_pressure,
    motivation = motivation,
    superordinate_clarity = superordinate_clarity,
    midlevel_planning = midlevel_planning,
    daily_action_alignment = daily_action_alignment,
    goal_hierarchy_coherence = goal_hierarchy_coherence,
    social_support = social_support,
    feedback_quality = feedback_quality,
    burnout = burnout,
    long_term_progress = long_term_progress
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-motivation-goal-hierarchy-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and progress: ", cor(df.grit, df.long_term_progress))
println("Correlation between motivation and progress: ", cor(df.motivation, df.long_term_progress))
println("Correlation between hierarchy coherence and progress: ", cor(df.goal_hierarchy_coherence, df.long_term_progress))
