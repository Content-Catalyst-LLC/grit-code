# Grit and Academic Persistence
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

self_control = randn(n)
prior_preparation = randn(n)
instructional_quality = randn(n)
feedback_quality = randn(n)
belonging = randn(n)
social_support = randn(n)
financial_stress = randn(n)
health_stability = randn(n)

study_effort =
    0.30 .* grit .+
    0.26 .* self_control .+
    0.18 .* belonging .+
    0.16 .* social_support .-
    0.18 .* financial_stress .+
    randn(n)

burnout =
    0.22 .* financial_stress .+
    0.18 .* study_effort .-
    0.22 .* social_support .-
    0.20 .* health_stability .-
    0.16 .* belonging .+
    randn(n)

academic_progress =
    0.18 .* grit .+
    0.24 .* study_effort .+
    0.26 .* prior_preparation .+
    0.20 .* instructional_quality .+
    0.18 .* feedback_quality .+
    0.18 .* belonging .+
    0.14 .* social_support .-
    0.18 .* burnout .+
    randn(n)

academic_persistence =
    0.20 .* grit .+
    0.18 .* self_control .+
    0.24 .* academic_progress .+
    0.22 .* belonging .+
    0.18 .* social_support .-
    0.20 .* financial_stress .-
    0.18 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    self_control = self_control,
    prior_preparation = prior_preparation,
    instructional_quality = instructional_quality,
    feedback_quality = feedback_quality,
    belonging = belonging,
    social_support = social_support,
    financial_stress = financial_stress,
    health_stability = health_stability,
    study_effort = study_effort,
    burnout = burnout,
    academic_progress = academic_progress,
    academic_persistence = academic_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-academic-persistence-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and academic persistence: ", cor(df.grit, df.academic_persistence))
println("Correlation between belonging and academic persistence: ", cor(df.belonging, df.academic_persistence))
println("Correlation between burnout and academic persistence: ", cor(df.burnout, df.academic_persistence))
