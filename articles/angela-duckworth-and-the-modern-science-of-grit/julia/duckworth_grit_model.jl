# Angela Duckworth and the Modern Science of Grit
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 750

perseverance_effort = randn(n)
consistency_interest = randn(n)

conscientiousness = 0.60 .* perseverance_effort .+ 0.80 .* randn(n)
self_control = 0.45 .* perseverance_effort .+ 0.90 .* randn(n)
social_support = randn(n)
prior_achievement = randn(n)

grit_score = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interest

achievement_outcome =
    0.18 .* grit_score .+
    0.34 .* prior_achievement .+
    0.22 .* conscientiousness .+
    0.15 .* self_control .+
    0.25 .* social_support .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interest = consistency_interest,
    grit_score = grit_score,
    conscientiousness = conscientiousness,
    self_control = self_control,
    social_support = social_support,
    prior_achievement = prior_achievement,
    achievement_outcome = achievement_outcome
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "duckworth-grit-modeled-data-julia.csv"), df)

println(describe(df))
