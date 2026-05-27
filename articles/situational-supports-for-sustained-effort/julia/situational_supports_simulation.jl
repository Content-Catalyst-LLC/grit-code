# Situational Supports for Sustained Effort
# Synthetic simulation for professional positive psychology.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 500

age = rand(14:69, n)
stage = [a < 18 ? "adolescence" : a < 30 ? "emerging_adulthood" : a < 55 ? "adulthood" : "later_adulthood" for a in age]

perseverance_effort = randn(n)
consistency_interests = randn(n)
grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

autonomy_support = randn(n)
feedback_quality = randn(n)
belonging = randn(n)
mentoring_access = randn(n)
recovery_capacity = randn(n)
material_resources = randn(n)
fairness = randn(n)
psychological_safety = randn(n)
chronic_stress = randn(n)
blocked_opportunity = randn(n)

situational_support =
    0.16 .* autonomy_support .+
    0.16 .* feedback_quality .+
    0.16 .* belonging .+
    0.12 .* mentoring_access .+
    0.14 .* recovery_capacity .+
    0.14 .* material_resources .+
    0.12 .* fairness .+
    0.10 .* psychological_safety

adaptive_persistence =
    0.24 .* grit .+
    0.26 .* situational_support .+
    0.14 .* feedback_quality .+
    0.12 .* recovery_capacity .+
    0.12 .* belonging .+
    0.10 .* mentoring_access .-
    0.18 .* chronic_stress .-
    0.14 .* blocked_opportunity .+
    0.12 .* grit .* situational_support .+
    randn(n)

df = DataFrame(
    age = age,
    developmental_stage = stage,
    grit = grit,
    situational_support = situational_support,
    autonomy_support = autonomy_support,
    feedback_quality = feedback_quality,
    belonging = belonging,
    mentoring_access = mentoring_access,
    recovery_capacity = recovery_capacity,
    material_resources = material_resources,
    fairness = fairness,
    psychological_safety = psychological_safety,
    chronic_stress = chronic_stress,
    blocked_opportunity = blocked_opportunity,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "situational-supports-simulation-julia.csv"), df)

println(combine(groupby(df, :developmental_stage), :grit => mean, :situational_support => mean, :adaptive_persistence => mean))
println("Correlation between situational support and adaptive persistence: ", cor(df.situational_support, df.adaptive_persistence))
println("Professional caution: synthetic simulation only.")
