# Grit and Narrative Identity
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

narrative_coherence = randn(n)
agency = randn(n)
meaning_making = randn(n)
future_orientation = randn(n)

narrative_identity =
    0.28 .* narrative_coherence .+
    0.26 .* agency .+
    0.24 .* meaning_making .+
    0.22 .* future_orientation

social_support = randn(n)
feedback_quality = randn(n)
opportunity_access = randn(n)
health_stability = randn(n)
institutional_trust = randn(n)

burnout =
    0.18 .* grit .-
    0.22 .* social_support .-
    0.20 .* health_stability .-
    0.16 .* institutional_trust .+
    randn(n)

narrative_strain =
    0.22 .* burnout .-
    0.24 .* social_support .-
    0.20 .* institutional_trust .-
    0.18 .* agency .+
    randn(n)

grit_narrative_interaction = grit .* narrative_identity

long_term_persistence =
    0.18 .* grit .+
    0.24 .* narrative_identity .+
    0.12 .* grit_narrative_interaction .+
    0.18 .* social_support .+
    0.16 .* feedback_quality .+
    0.18 .* opportunity_access .+
    0.14 .* institutional_trust .-
    0.18 .* burnout .-
    0.10 .* narrative_strain .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    narrative_coherence = narrative_coherence,
    agency = agency,
    meaning_making = meaning_making,
    future_orientation = future_orientation,
    narrative_identity = narrative_identity,
    social_support = social_support,
    feedback_quality = feedback_quality,
    opportunity_access = opportunity_access,
    health_stability = health_stability,
    institutional_trust = institutional_trust,
    burnout = burnout,
    narrative_strain = narrative_strain,
    grit_narrative_interaction = grit_narrative_interaction,
    long_term_persistence = long_term_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-narrative-identity-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and long-term persistence: ", cor(df.grit, df.long_term_persistence))
println("Correlation between narrative identity and long-term persistence: ", cor(df.narrative_identity, df.long_term_persistence))
println("Correlation between narrative strain and long-term persistence: ", cor(df.narrative_strain, df.long_term_persistence))
