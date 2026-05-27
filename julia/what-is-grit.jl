# What Is Grit? — Julia synthetic-data sketch

using Random
using Statistics
using DataFrames
using CSV

Random.seed!(42)

n = 500

perseverance_effort = randn(n)
consistency_interest = randn(n)
conscientiousness = 0.55 .* perseverance_effort .+ 0.85 .* randn(n)
social_support = randn(n)
prior_achievement = randn(n)

grit_score = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interest

achievement_outcome =
    0.25 .* grit_score .+
    0.35 .* prior_achievement .+
    0.20 .* conscientiousness .+
    0.25 .* social_support .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interest = consistency_interest,
    grit_score = grit_score,
    conscientiousness = conscientiousness,
    social_support = social_support,
    prior_achievement = prior_achievement,
    achievement_outcome = achievement_outcome
)

mkpath("data/processed")
CSV.write("data/processed/what-is-grit-modeled-data-julia.csv", df)

println(describe(df))
