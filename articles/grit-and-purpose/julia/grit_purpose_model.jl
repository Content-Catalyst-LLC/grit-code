# Grit and Purpose
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

personal_meaning = randn(n)
long_term_direction = randn(n)
beyond_self_contribution = randn(n)

purpose =
    0.34 .* personal_meaning .+
    0.33 .* long_term_direction .+
    0.33 .* beyond_self_contribution

social_support = randn(n)
feedback_quality = randn(n)
opportunity_access = randn(n)
autonomy_support = randn(n)
health_stability = randn(n)

burnout =
    0.18 .* grit .+
    0.16 .* purpose .-
    0.24 .* social_support .-
    0.22 .* autonomy_support .-
    0.20 .* health_stability .+
    randn(n)

grit_purpose_interaction = grit .* purpose

long_term_persistence =
    0.20 .* grit .+
    0.26 .* purpose .+
    0.12 .* grit_purpose_interaction .+
    0.18 .* social_support .+
    0.16 .* feedback_quality .+
    0.18 .* opportunity_access .+
    0.16 .* autonomy_support .-
    0.20 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    personal_meaning = personal_meaning,
    long_term_direction = long_term_direction,
    beyond_self_contribution = beyond_self_contribution,
    purpose = purpose,
    social_support = social_support,
    feedback_quality = feedback_quality,
    opportunity_access = opportunity_access,
    autonomy_support = autonomy_support,
    health_stability = health_stability,
    burnout = burnout,
    grit_purpose_interaction = grit_purpose_interaction,
    long_term_persistence = long_term_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-purpose-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and long-term persistence: ", cor(df.grit, df.long_term_persistence))
println("Correlation between purpose and long-term persistence: ", cor(df.purpose, df.long_term_persistence))
println("Correlation between burnout and long-term persistence: ", cor(df.burnout, df.long_term_persistence))
