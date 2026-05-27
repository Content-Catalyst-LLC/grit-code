# Grit in Positive Psychology
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 800

perseverance_effort = randn(n)
durable_interest = randn(n)

meaning = randn(n)
relationships = randn(n)
social_support = 0.50 .* relationships .+ 0.85 .* randn(n)
health_resources = randn(n)
depletion = randn(n)

grit_score = 0.60 .* perseverance_effort .+ 0.40 .* durable_interest

flourishing =
    0.18 .* grit_score .+
    0.30 .* meaning .+
    0.25 .* relationships .+
    0.22 .* social_support .+
    0.20 .* health_resources .-
    0.28 .* depletion .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    durable_interest = durable_interest,
    grit_score = grit_score,
    meaning = meaning,
    relationships = relationships,
    social_support = social_support,
    health_resources = health_resources,
    depletion = depletion,
    flourishing = flourishing
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-positive-psychology-modeled-data-julia.csv"), df)

println(describe(df))
