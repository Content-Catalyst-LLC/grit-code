# When Quitting Is Adaptive
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

cumulative_cost = randn(n)
health_risk = randn(n)
goal_misalignment = randn(n)
opportunity_cost = randn(n)

future_value = randn(n)
learning_potential = randn(n)
purpose_alignment = randn(n)

social_support = randn(n)
financial_security = randn(n)
feedback_responsiveness = randn(n)
sunk_cost = randn(n)
identity_pressure = randn(n)

alternative_meaning = randn(n)
alternative_feasibility = randn(n)
alternative_support = randn(n)
transition_cost = randn(n)

alternative_goal_value =
    0.30 .* alternative_meaning .+
    0.28 .* alternative_feasibility .+
    0.24 .* alternative_support .-
    0.18 .* transition_cost

quitting_pressure =
    0.24 .* cumulative_cost .+
    0.26 .* health_risk .+
    0.24 .* goal_misalignment .+
    0.20 .* opportunity_cost .-
    0.24 .* future_value .-
    0.20 .* learning_potential .-
    0.24 .* purpose_alignment

overpersistence_risk =
    0.18 .* grit .+
    0.24 .* sunk_cost .+
    0.24 .* identity_pressure .-
    0.24 .* feedback_responsiveness .-
    0.22 .* purpose_alignment .+
    randn(n)

adaptive_quitting_readiness =
    0.28 .* quitting_pressure .+
    0.26 .* alternative_goal_value .+
    0.18 .* social_support .+
    0.16 .* financial_security .+
    0.16 .* feedback_responsiveness .-
    0.20 .* overpersistence_risk .+
    randn(n)

sustainable_persistence =
    0.20 .* grit .+
    0.26 .* purpose_alignment .+
    0.22 .* future_value .+
    0.20 .* learning_potential .+
    0.18 .* feedback_responsiveness .+
    0.16 .* social_support .-
    0.26 .* quitting_pressure .-
    0.18 .* health_risk .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    cumulative_cost = cumulative_cost,
    health_risk = health_risk,
    goal_misalignment = goal_misalignment,
    opportunity_cost = opportunity_cost,
    future_value = future_value,
    learning_potential = learning_potential,
    purpose_alignment = purpose_alignment,
    social_support = social_support,
    financial_security = financial_security,
    feedback_responsiveness = feedback_responsiveness,
    sunk_cost = sunk_cost,
    identity_pressure = identity_pressure,
    alternative_meaning = alternative_meaning,
    alternative_feasibility = alternative_feasibility,
    alternative_support = alternative_support,
    transition_cost = transition_cost,
    alternative_goal_value = alternative_goal_value,
    quitting_pressure = quitting_pressure,
    overpersistence_risk = overpersistence_risk,
    adaptive_quitting_readiness = adaptive_quitting_readiness,
    sustainable_persistence = sustainable_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "when-quitting-is-adaptive-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and sustainable persistence: ", cor(df.grit, df.sustainable_persistence))
println("Correlation between quitting pressure and adaptive quitting readiness: ", cor(df.quitting_pressure, df.adaptive_quitting_readiness))
println("Correlation between alternative goal value and adaptive quitting readiness: ", cor(df.alternative_goal_value, df.adaptive_quitting_readiness))
