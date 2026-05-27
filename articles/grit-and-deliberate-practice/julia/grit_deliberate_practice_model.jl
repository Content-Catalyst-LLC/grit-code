# Grit and Deliberate Practice
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

feedback_quality = randn(n)
coaching_access = randn(n)
prior_skill = randn(n)
social_support = randn(n)

deliberate_practice =
    0.35 .* grit .+
    0.28 .* feedback_quality .+
    0.22 .* coaching_access .+
    0.15 .* social_support .+
    randn(n)

burnout =
    0.20 .* deliberate_practice .-
    0.25 .* social_support .-
    0.20 .* feedback_quality .+
    randn(n)

performance =
    0.16 .* grit .+
    0.34 .* deliberate_practice .+
    0.28 .* prior_skill .+
    0.18 .* feedback_quality .+
    0.16 .* coaching_access .+
    0.14 .* social_support .-
    0.18 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    feedback_quality = feedback_quality,
    coaching_access = coaching_access,
    prior_skill = prior_skill,
    social_support = social_support,
    deliberate_practice = deliberate_practice,
    burnout = burnout,
    performance = performance
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-deliberate-practice-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and deliberate practice: ", cor(df.grit, df.deliberate_practice))
println("Correlation between deliberate practice and performance: ", cor(df.deliberate_practice, df.performance))
println("Correlation between grit and performance: ", cor(df.grit, df.performance))
