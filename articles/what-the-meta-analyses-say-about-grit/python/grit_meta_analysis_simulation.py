"""
What the Meta-Analyses Say About Grit

Synthetic study-level workflow for demonstrating pooled correlations,
Fisher's z transformation, and facet-level comparison.

This script is for article support and research-method demonstration only.
It is not a substitute for a real systematic review or meta-analysis.
"""

from pathlib import Path

import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-meta-analysis-synthetic-studies-python.csv"
SUMMARY_OUT = ROOT / "outputs" / "tables" / "grit-meta-analysis-pooled-effects-python.csv"

rng = np.random.default_rng(42)

k = 60
sample_size = rng.integers(150, 2500, size=k)

r_total_grit = np.clip(rng.normal(0.18, 0.08, size=k), -0.10, 0.45)
r_perseverance = np.clip(rng.normal(0.22, 0.08, size=k), -0.10, 0.50)
r_consistency = np.clip(rng.normal(0.08, 0.07, size=k), -0.15, 0.35)

outcome_domain = rng.choice(
    ["academic", "performance", "retention", "wellbeing"],
    size=k,
    replace=True,
    p=[0.45, 0.25, 0.20, 0.10],
)

df = pd.DataFrame(
    {
        "study_id": [f"study_{i+1:02d}" for i in range(k)],
        "sample_size": sample_size,
        "r_total_grit": r_total_grit,
        "r_perseverance": r_perseverance,
        "r_consistency": r_consistency,
        "outcome_domain": outcome_domain,
    }
)


def fisher_z(r: np.ndarray) -> np.ndarray:
    return 0.5 * np.log((1 + r) / (1 - r))


def inverse_fisher_z(z: float) -> float:
    return (np.exp(2 * z) - 1) / (np.exp(2 * z) + 1)


def fixed_effect_meta_r(r_values: np.ndarray, n_values: np.ndarray) -> dict:
    z_values = fisher_z(r_values)
    variances = 1 / (n_values - 3)
    weights = 1 / variances

    pooled_z = np.sum(weights * z_values) / np.sum(weights)
    pooled_se = np.sqrt(1 / np.sum(weights))

    lower_z = pooled_z - 1.96 * pooled_se
    upper_z = pooled_z + 1.96 * pooled_se

    return {
        "pooled_r": inverse_fisher_z(pooled_z),
        "ci_lower": inverse_fisher_z(lower_z),
        "ci_upper": inverse_fisher_z(upper_z),
    }


summary = pd.DataFrame(
    [
        {"facet": "total_grit", **fixed_effect_meta_r(df["r_total_grit"].to_numpy(), df["sample_size"].to_numpy())},
        {"facet": "perseverance_of_effort", **fixed_effect_meta_r(df["r_perseverance"].to_numpy(), df["sample_size"].to_numpy())},
        {"facet": "consistency_of_interests", **fixed_effect_meta_r(df["r_consistency"].to_numpy(), df["sample_size"].to_numpy())},
    ]
)

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
SUMMARY_OUT.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(DATA_OUT, index=False)
summary.to_csv(SUMMARY_OUT, index=False)

print("Saved synthetic study data:", DATA_OUT)
print("Saved pooled effect summary:", SUMMARY_OUT)
print(summary.round(3))
