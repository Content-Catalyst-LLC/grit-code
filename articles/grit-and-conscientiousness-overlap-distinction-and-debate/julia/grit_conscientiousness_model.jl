# Grit and Conscientiousness: Overlap, Distinction, and Debate
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 900

industriousness = randn(n)
orderliness = randn(n)
dependability = randn(n)
responsibility = randn(n)
achievement_striving = randn(n)

conscientiousness =
    0.30 .* industriousness .+
    0.18 .* orderliness .+
    0.18 .* dependability .+
    0.17 .* responsibility .+
    0.17 .* achievement_striving

perseverance_effort =
    0.55 .* industriousness .+
    0.25 .* achievement_striving .+
    0.85 .* randn(n)

consistency_interests =
    0.20 .* achievement_striving .+
    randn(n)

grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

prior_achievement = randn(n)
social_support = randn(n)
burnout = randn(n)

long_term_progress =
    0.24 .* conscientiousness .+
    0.18 .* grit .+
    0.22 .* prior_achievement .+
    0.18 .* social_support .-
    0.20 .* burnout .+
    randn(n)

df = DataFrame(
    industriousness = industriousness,
    orderliness = orderliness,
    dependability = dependability,
    responsibility = responsibility,
    achievement_striving = achievement_striving,
    conscientiousness = conscientiousness,
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    prior_achievement = prior_achievement,
    social_support = social_support,
    burnout = burnout,
    long_term_progress = long_term_progress
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-conscientiousness-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and conscientiousness: ", cor(df.grit, df.conscientiousness))
println("Correlation between perseverance and conscientiousness: ", cor(df.perseverance_effort, df.conscientiousness))
println("Correlation between consistency and conscientiousness: ", cor(df.consistency_interests, df.conscientiousness))
