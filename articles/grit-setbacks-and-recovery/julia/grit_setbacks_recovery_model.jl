# Grit, Setbacks, and Recovery
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

setback_severity = randn(n)
emotional_recovery = randn(n)
cognitive_recovery = randn(n)
physical_restoration = randn(n)
social_support = randn(n)
practical_resources = randn(n)
feedback_quality = randn(n)
opportunity_access = randn(n)

recovery_capacity =
    0.22 .* emotional_recovery .+
    0.22 .* cognitive_recovery .+
    0.18 .* physical_restoration .+
    0.20 .* social_support .+
    0.18 .* practical_resources

burnout =
    0.24 .* setback_severity .+
    0.18 .* grit .-
    0.24 .* recovery_capacity .-
    0.20 .* social_support .+
    randn(n)

grit_recovery_interaction = grit .* recovery_capacity

adaptive_persistence =
    0.18 .* grit .-
    0.22 .* setback_severity .+
    0.28 .* recovery_capacity .+
    0.12 .* grit_recovery_interaction .+
    0.18 .* feedback_quality .+
    0.18 .* opportunity_access .+
    0.14 .* social_support .-
    0.20 .* burnout .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    setback_severity = setback_severity,
    emotional_recovery = emotional_recovery,
    cognitive_recovery = cognitive_recovery,
    physical_restoration = physical_restoration,
    social_support = social_support,
    practical_resources = practical_resources,
    feedback_quality = feedback_quality,
    opportunity_access = opportunity_access,
    recovery_capacity = recovery_capacity,
    burnout = burnout,
    grit_recovery_interaction = grit_recovery_interaction,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-setbacks-recovery-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and adaptive persistence: ", cor(df.grit, df.adaptive_persistence))
println("Correlation between recovery capacity and adaptive persistence: ", cor(df.recovery_capacity, df.adaptive_persistence))
println("Correlation between burnout and adaptive persistence: ", cor(df.burnout, df.adaptive_persistence))
