# Grit and Long-Term Achievement
# Synthetic-data workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 1000

perseverance_effort = randn(n)
consistency_interests = randn(n)
grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

prior_preparation = randn(n)
deliberate_practice = 0.35 .* grit .+ 0.25 .* prior_preparation .+ randn(n)
feedback_quality = randn(n)
social_support = randn(n)
opportunity_access = randn(n)
health_stability = randn(n)

burnout =
    0.20 .* grit .+
    0.18 .* deliberate_practice .-
    0.25 .* social_support .-
    0.20 .* health_stability .+
    randn(n)

long_term_achievement =
    0.16 .* grit .+
    0.30 .* deliberate_practice .+
    0.26 .* prior_preparation .+
    0.18 .* feedback_quality .+
    0.20 .* social_support .+
    0.24 .* opportunity_access .+
    0.14 .* health_stability .-
    0.18 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    prior_preparation = prior_preparation,
    deliberate_practice = deliberate_practice,
    feedback_quality = feedback_quality,
    social_support = social_support,
    opportunity_access = opportunity_access,
    health_stability = health_stability,
    burnout = burnout,
    long_term_achievement = long_term_achievement
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-long-term-achievement-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and long-term achievement: ", cor(df.grit, df.long_term_achievement))
println("Correlation between deliberate practice and long-term achievement: ", cor(df.deliberate_practice, df.long_term_achievement))
println("Correlation between opportunity access and long-term achievement: ", cor(df.opportunity_access, df.long_term_achievement))
