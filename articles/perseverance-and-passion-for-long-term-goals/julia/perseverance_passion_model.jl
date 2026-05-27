# Perseverance and Passion for Long-Term Goals
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 700

perseverance_effort = randn(n)
durable_passion = randn(n)

conscientiousness = 0.55 .* perseverance_effort .+ 0.85 .* randn(n)
social_support = randn(n)
prior_achievement = randn(n)

grit_score = 0.60 .* perseverance_effort .+ 0.40 .* durable_passion

long_term_outcome =
    0.22 .* grit_score .+
    0.34 .* prior_achievement .+
    0.24 .* conscientiousness .+
    0.26 .* social_support .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    durable_passion = durable_passion,
    grit_score = grit_score,
    conscientiousness = conscientiousness,
    social_support = social_support,
    prior_achievement = prior_achievement,
    long_term_outcome = long_term_outcome
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "perseverance-passion-modeled-data-julia.csv"), df)

println(describe(df))
