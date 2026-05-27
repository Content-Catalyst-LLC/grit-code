# The Development of Grit Across Adolescence and Adulthood
# Synthetic workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 500

age = rand([12, 14, 16, 18, 22, 30, 40, 55, 65], n)
support = randn(n)
feedback_quality = randn(n)
purpose = randn(n)
recovery_capacity = randn(n)
chronic_stress = randn(n)
opportunity_access = randn(n)

stage = [a < 18 ? "adolescence" : a < 30 ? "emerging_adulthood" : a < 55 ? "adulthood" : "later_adulthood" for a in age]

perseverance_effort =
    0.18 .* support .+
    0.18 .* feedback_quality .+
    0.20 .* purpose .+
    0.15 .* recovery_capacity .+
    0.12 .* opportunity_access .-
    0.18 .* chronic_stress .+
    randn(n)

consistency_interests =
    0.22 .* purpose .+
    0.12 .* opportunity_access .+
    0.10 .* support .-
    0.10 .* chronic_stress .+
    randn(n)

grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

adaptive_persistence =
    0.24 .* grit .+
    0.20 .* support .+
    0.18 .* feedback_quality .+
    0.20 .* purpose .+
    0.16 .* recovery_capacity .+
    0.16 .* opportunity_access .-
    0.20 .* chronic_stress .+
    randn(n)

df = DataFrame(
    age = age,
    stage = stage,
    support = support,
    feedback_quality = feedback_quality,
    purpose = purpose,
    recovery_capacity = recovery_capacity,
    chronic_stress = chronic_stress,
    opportunity_access = opportunity_access,
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "development-of-grit-life-course-modeled-data-julia.csv"), df)

println(combine(groupby(df, :stage), :grit => mean, :adaptive_persistence => mean))
