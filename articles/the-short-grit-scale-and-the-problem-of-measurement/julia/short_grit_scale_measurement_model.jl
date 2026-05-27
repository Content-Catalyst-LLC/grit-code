# The Short Grit Scale and the Problem of Measurement
# Synthetic-data workflow sketch.
# This file does not reproduce copyrighted scale items.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 900

perseverance_effort = randn(n)
consistency_interest = randn(n)
conscientiousness = 0.60 .* perseverance_effort .+ 0.85 .* randn(n)
prior_achievement = randn(n)
social_support = randn(n)

true_grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interest
measurement_error = 0.35 .* randn(n)
observed_grit_s = true_grit .+ measurement_error

long_term_outcome =
    0.18 .* observed_grit_s .+
    0.30 .* prior_achievement .+
    0.24 .* conscientiousness .+
    0.25 .* social_support .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interest = consistency_interest,
    true_grit = true_grit,
    measurement_error = measurement_error,
    observed_grit_s = observed_grit_s,
    conscientiousness = conscientiousness,
    prior_achievement = prior_achievement,
    social_support = social_support,
    long_term_outcome = long_term_outcome
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "short-grit-scale-modeled-data-julia.csv"), df)

println(describe(df))
