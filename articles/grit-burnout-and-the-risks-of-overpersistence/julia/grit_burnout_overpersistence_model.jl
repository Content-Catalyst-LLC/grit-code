# Grit, Burnout, and the Risks of Overpersistence
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

demand_intensity = randn(n)
goal_rigidity = randn(n)
identity_pressure = randn(n)
sunk_cost = randn(n)
recovery_capacity = randn(n)
social_support = randn(n)
autonomy = randn(n)
feedback_responsiveness = randn(n)
goal_fit = randn(n)

overpersistence =
    0.22 .* grit .+
    0.24 .* sunk_cost .+
    0.22 .* identity_pressure .+
    0.20 .* goal_rigidity .-
    0.22 .* feedback_responsiveness .-
    0.20 .* goal_fit .+
    randn(n)

burnout_risk =
    0.24 .* demand_intensity .+
    0.22 .* overpersistence .+
    0.18 .* goal_rigidity .+
    0.16 .* grit .-
    0.26 .* recovery_capacity .-
    0.20 .* social_support .-
    0.18 .* autonomy .+
    randn(n)

sustainable_persistence =
    0.20 .* grit .+
    0.24 .* goal_fit .+
    0.22 .* feedback_responsiveness .+
    0.20 .* recovery_capacity .+
    0.18 .* social_support .+
    0.18 .* autonomy .-
    0.24 .* burnout_risk .-
    0.16 .* overpersistence .+
    randn(n)

df = DataFrame(
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    demand_intensity = demand_intensity,
    goal_rigidity = goal_rigidity,
    identity_pressure = identity_pressure,
    sunk_cost = sunk_cost,
    recovery_capacity = recovery_capacity,
    social_support = social_support,
    autonomy = autonomy,
    feedback_responsiveness = feedback_responsiveness,
    goal_fit = goal_fit,
    overpersistence = overpersistence,
    burnout_risk = burnout_risk,
    sustainable_persistence = sustainable_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-burnout-overpersistence-modeled-data-julia.csv"), df)

println(describe(df))
println("Correlation between grit and burnout risk: ", cor(df.grit, df.burnout_risk))
println("Correlation between overpersistence and burnout risk: ", cor(df.overpersistence, df.burnout_risk))
println("Correlation between recovery capacity and sustainable persistence: ", cor(df.recovery_capacity, df.sustainable_persistence))
