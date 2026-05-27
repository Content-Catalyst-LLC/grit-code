# Designing Environments That Support Grit
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
competence_support = randn(n)
feedback_quality = randn(n)
belonging = randn(n)
mentoring_access = randn(n)
recovery_design = randn(n)
material_resources = randn(n)
fairness = randn(n)
psychological_safety = randn(n)
adaptive_quitting_norms = randn(n)
chronic_stress = randn(n)
blocked_opportunity = randn(n)

environment_design =
    0.13 .* autonomy_support .+
    0.13 .* competence_support .+
    0.13 .* feedback_quality .+
    0.12 .* belonging .+
    0.10 .* mentoring_access .+
    0.13 .* recovery_design .+
    0.10 .* material_resources .+
    0.11 .* fairness .+
    0.10 .* psychological_safety .+
    0.05 .* adaptive_quitting_norms

adaptive_persistence =
    0.24 .* grit .+
    0.30 .* environment_design .+
    0.12 .* feedback_quality .+
    0.12 .* recovery_design .+
    0.10 .* belonging .+
    0.10 .* fairness .-
    0.18 .* chronic_stress .-
    0.14 .* blocked_opportunity .+
    0.12 .* grit .* environment_design .+
    randn(n)

df = DataFrame(
    age = age,
    developmental_stage = stage,
    grit = grit,
    environment_design = environment_design,
    autonomy_support = autonomy_support,
    competence_support = competence_support,
    feedback_quality = feedback_quality,
    belonging = belonging,
    mentoring_access = mentoring_access,
    recovery_design = recovery_design,
    material_resources = material_resources,
    fairness = fairness,
    psychological_safety = psychological_safety,
    adaptive_quitting_norms = adaptive_quitting_norms,
    chronic_stress = chronic_stress,
    blocked_opportunity = blocked_opportunity,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "environmental-design-simulation-julia.csv"), df)

println(combine(groupby(df, :developmental_stage), :grit => mean, :environment_design => mean, :adaptive_persistence => mean))
println("Correlation between environment design and adaptive persistence: ", cor(df.environment_design, df.adaptive_persistence))
println("Professional caution: synthetic simulation only.")
