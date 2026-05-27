# Grit in Comparative Perspective
# Synthetic comparative construct simulation for professional positive psychology.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 500

age = rand(14:69, n)
stage = [a < 18 ? "adolescence" : a < 30 ? "emerging_adulthood" : a < 55 ? "adulthood" : "later_adulthood" for a in age]

self_control = randn(n)
conscientiousness = 0.40 .* self_control .+ randn(n)
resilience_recovery = randn(n)
deliberate_practice_quality = randn(n)
purpose_alignment = randn(n)
environmental_support = randn(n)
chronic_stress = randn(n)

perseverance_effort =
    0.30 .* conscientiousness .+
    0.18 .* self_control .+
    0.20 .* purpose_alignment .+
    0.14 .* environmental_support .+
    randn(n)

consistency_interests =
    0.22 .* conscientiousness .+
    0.12 .* self_control .+
    0.28 .* purpose_alignment .+
    0.10 .* environmental_support .+
    randn(n)

grit = 0.60 .* perseverance_effort .+ 0.40 .* consistency_interests

adaptive_persistence =
    0.22 .* grit .+
    0.16 .* self_control .+
    0.16 .* deliberate_practice_quality .+
    0.16 .* purpose_alignment .+
    0.18 .* environmental_support .+
    0.14 .* resilience_recovery .-
    0.16 .* chronic_stress .+
    0.10 .* grit .* environmental_support .+
    randn(n)

df = DataFrame(
    age = age,
    developmental_stage = stage,
    self_control = self_control,
    conscientiousness = conscientiousness,
    resilience_recovery = resilience_recovery,
    deliberate_practice_quality = deliberate_practice_quality,
    purpose_alignment = purpose_alignment,
    environmental_support = environmental_support,
    chronic_stress = chronic_stress,
    perseverance_effort = perseverance_effort,
    consistency_interests = consistency_interests,
    grit = grit,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "comparative-construct-simulation-julia.csv"), df)

println(combine(groupby(df, :developmental_stage), :grit => mean, :self_control => mean, :conscientiousness => mean, :adaptive_persistence => mean))
println("Correlation between grit and conscientiousness: ", cor(df.grit, df.conscientiousness))
println("Professional caution: synthetic simulation only.")
