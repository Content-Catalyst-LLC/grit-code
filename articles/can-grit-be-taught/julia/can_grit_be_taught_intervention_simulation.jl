# Can Grit Be Taught?
# Synthetic intervention simulation for professional positive psychology.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

n = 500

age = rand(14:64, n)
stage = [a < 18 ? "adolescence" : a < 30 ? "emerging_adulthood" : a < 55 ? "adulthood" : "later_adulthood" for a in age]

baseline_support = randn(n)
baseline_stress = randn(n)
baseline_recovery = 0.35 .* baseline_support .- 0.25 .* baseline_stress .+ randn(n)
baseline_grit = 0.30 .* baseline_support .+ 0.25 .* baseline_recovery .- 0.20 .* baseline_stress .+ randn(n)

treatment = rand(0:1, n)
implementation_quality = randn(n)

post_recovery_capacity =
    0.18 .* treatment .+
    0.45 .* baseline_recovery .+
    0.20 .* baseline_support .-
    0.20 .* baseline_stress .+
    randn(n)

post_grit =
    0.55 .* baseline_grit .+
    0.18 .* treatment .+
    0.18 .* treatment .* baseline_support .+
    0.16 .* post_recovery_capacity .-
    0.16 .* baseline_stress .+
    randn(n)

adaptive_persistence =
    0.30 .* post_grit .+
    0.20 .* post_recovery_capacity .+
    0.18 .* baseline_support .-
    0.18 .* baseline_stress .+
    randn(n)

df = DataFrame(
    age = age,
    developmental_stage = stage,
    baseline_support = baseline_support,
    baseline_stress = baseline_stress,
    baseline_recovery = baseline_recovery,
    baseline_grit = baseline_grit,
    treatment = treatment,
    implementation_quality = implementation_quality,
    post_recovery_capacity = post_recovery_capacity,
    post_grit = post_grit,
    adaptive_persistence = adaptive_persistence
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
CSV.write(joinpath(@__DIR__, "..", "data", "processed", "can-grit-be-taught-intervention-simulation-julia.csv"), df)

println(combine(groupby(df, :treatment), :post_grit => mean, :adaptive_persistence => mean))
println("Professional caution: synthetic simulation only.")
