# What the Meta-Analyses Say About Grit
# Synthetic meta-analysis workflow sketch.

using Random
using DataFrames
using CSV
using Statistics

Random.seed!(42)

k = 60
sample_size = rand(150:2500, k)

clampvec(x, lo, hi) = [min(max(v, lo), hi) for v in x]

r_total_grit = clampvec(0.18 .+ 0.08 .* randn(k), -0.10, 0.45)
r_perseverance = clampvec(0.22 .+ 0.08 .* randn(k), -0.10, 0.50)
r_consistency = clampvec(0.08 .+ 0.07 .* randn(k), -0.15, 0.35)

df = DataFrame(
    study_id = ["study_" * lpad(string(i), 2, "0") for i in 1:k],
    sample_size = sample_size,
    r_total_grit = r_total_grit,
    r_perseverance = r_perseverance,
    r_consistency = r_consistency
)

fisher_z(r) = 0.5 * log((1 + r) / (1 - r))
inverse_fisher_z(z) = (exp(2z) - 1) / (exp(2z) + 1)

function fixed_effect_meta_r(r_values, n_values)
    z_values = fisher_z.(r_values)
    variances = 1.0 ./ (n_values .- 3)
    weights = 1.0 ./ variances
    pooled_z = sum(weights .* z_values) / sum(weights)
    pooled_r = inverse_fisher_z(pooled_z)
    return pooled_r
end

summary = DataFrame(
    facet = ["total_grit", "perseverance_of_effort", "consistency_of_interests"],
    pooled_r = [
        fixed_effect_meta_r(r_total_grit, sample_size),
        fixed_effect_meta_r(r_perseverance, sample_size),
        fixed_effect_meta_r(r_consistency, sample_size)
    ]
)

mkpath(joinpath(@__DIR__, "..", "data", "processed"))
mkpath(joinpath(@__DIR__, "..", "outputs", "tables"))

CSV.write(joinpath(@__DIR__, "..", "data", "processed", "grit-meta-analysis-synthetic-studies-julia.csv"), df)
CSV.write(joinpath(@__DIR__, "..", "outputs", "tables", "grit-meta-analysis-summary-julia.csv"), summary)

println(summary)
