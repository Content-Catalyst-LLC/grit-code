# Why Grit Still Matters
# Synthetic adaptive-persistence simulation for professional positive psychology.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 600

age = rand(14:69, n)
stage = [a < 18 ? "adolescence" : a < 30 ? "emerging_adulthood" : a < 55 ? "adulthood" : "later_adulthood" for a in age]

self_control = randn(n)
conscientiousness = 0.40 .* self_control .+ randn(n)
purpose_alignment = randn(n)
feedback_quality = randn(n)
recovery_capacity = randn(n)
environmental_support = randn(n)
social_support = randn(n)
practice_quality = randn(n)
chronic_stress = randn(n)
blocked_opportunity = randn(n)

perseverance_effort =
    0.28 .* conscientiousness .+
    0.18 .* self_control .+
    0.22 .* purpose_alignment .+
    0.12 .* environmental_support .+
    randn(n)

consistency_interests =
    0.22 .* conscientiousness .+
    0.12 .* self_control .+
    0.30 .* purpose_alignment .+
    0.10 .* environmental_support .+
    randn(n)

grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

adaptive_persistence =
    0.22 .* grit .+
    0.14 .* self_control .+
    0.14 .* practice_quality .+
    0.16 .* purpose_alignment .+
    0.16 .* feedback_quality .+
    0.16 .* recovery_capacity .+
    0.18 .* environmental_support .+
    0.12 .* social_support .-
    0.14 .* chronic_stress .-
    0.12 .* blocked_opportunity .+
    0.10 .* grit .* environmental_support .+
    randn(n)

df = DataFrame(
    age = age,
    developmental_stage = stage,
    self_control = self_control,
    conscientiousness = conscientiousness,
    purpose_alignment = purpose_alignment,
    feedback_quality = feedback_quality,
    recovery_capacity = recovery_capacity,
    environmental_support = environmental_support,
    social_support = social_support,
    practice_quality = practice_quality,
    chronic_stress = chronic_stress,
    blocked_opportunity = blocked_opportunity,
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "why-grit-still-matters-simulation-julia.csv"), df)

println(combine(groupby(df, :developmental_stage), :grit => mean, :adaptive_persistence => mean, :environmental_support => mean))
println("Correlation between grit and adaptive persistence: ", cor(df.grit, df.adaptive_persistence))
println("Professional caution: synthetic simulation only.")
