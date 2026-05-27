# Perseverance of Effort Versus Consistency of Interests
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 900

perseverance_effort = randn(n)
consistency_interests = randn(n)

conscientiousness = 0.62 .* perseverance_effort .+ 0.80 .* randn(n)
self_control = 0.45 .* perseverance_effort .+ 0.90 .* randn(n)
social_support = randn(n)
prior_achievement = randn(n)
burnout = randn(n)

grit_total = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

long_term_outcome =
    0.28 .* perseverance_effort .+
    0.08 .* consistency_interests .+
    0.25 .* prior_achievement .+
    0.18 .* conscientiousness .+
    0.20 .* social_support .-
    0.22 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit_total = grit_total,
    conscientiousness = conscientiousness,
    self_control = self_control,
    social_support = social_support,
    prior_achievement = prior_achievement,
    burnout = burnout,
    long_term_outcome = long_term_outcome
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-facet-comparison-modeled-data-julia.csv"), df)

println(describe(df))
