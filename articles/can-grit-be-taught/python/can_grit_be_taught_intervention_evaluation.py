"""
Intervention evaluation workflow for "Can Grit Be Taught?"

Synthetic data only. Demonstrates pre/post change, intervention effects,
moderation by support, and burnout-risk safety monitoring.
"""

from pathlib import Path
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "outputs" / "tables"
PROCESSED = ROOT / "data" / "processed"
OUT.mkdir(parents=True, exist_ok=True)
PROCESSED.mkdir(parents=True, exist_ok=True)

rng = np.random.default_rng(42)
n = 800

age = rng.integers(14, 65, n)
developmental_stage = np.where(
    age < 18,
    "adolescence",
    np.where(age < 30, "emerging_adulthood", np.where(age < 55, "adulthood", "later_adulthood")),
)

baseline_support = rng.normal(0, 1, n)
baseline_stress = rng.normal(0, 1, n)
baseline_recovery = 0.35 * baseline_support - 0.25 * baseline_stress + rng.normal(0, 1, n)
baseline_grit = 0.30 * baseline_support + 0.25 * baseline_recovery - 0.20 * baseline_stress + rng.normal(0, 1, n)
baseline_burnout = 0.35 * baseline_stress - 0.30 * baseline_recovery - 0.20 * baseline_support + rng.normal(0, 1, n)

treatment = rng.binomial(1, 0.5, n)
implementation_quality = rng.normal(0, 1, n)

post_feedback_responsiveness = (
    0.40 * treatment
    + 0.25 * implementation_quality
    + 0.20 * baseline_support
    + rng.normal(0, 1, n)
)

post_purpose_alignment = (
    0.28 * treatment
    + 0.25 * baseline_grit
    + 0.20 * baseline_support
    + rng.normal(0, 1, n)
)

post_recovery_capacity = (
    0.18 * treatment
    + 0.45 * baseline_recovery
    + 0.20 * baseline_support
    - 0.20 * baseline_stress
    + rng.normal(0, 1, n)
)

post_grit = (
    0.55 * baseline_grit
    + 0.18 * treatment
    + 0.18 * treatment * baseline_support
    + 0.20 * post_feedback_responsiveness
    + 0.20 * post_purpose_alignment
    + 0.16 * post_recovery_capacity
    - 0.16 * baseline_stress
    + rng.normal(0, 1, n)
)

adaptive_persistence = (
    0.30 * post_grit
    + 0.22 * post_feedback_responsiveness
    + 0.20 * post_purpose_alignment
    + 0.18 * post_recovery_capacity
    + 0.18 * baseline_support
    - 0.18 * baseline_stress
    + rng.normal(0, 1, n)
)

post_burnout = (
    0.55 * baseline_burnout
    + 0.24 * baseline_stress
    - 0.24 * post_recovery_capacity
    - 0.16 * baseline_support
    + 0.06 * treatment
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "age": age,
        "developmental_stage": developmental_stage,
        "baseline_support": baseline_support,
        "baseline_stress": baseline_stress,
        "baseline_recovery": baseline_recovery,
        "baseline_grit": baseline_grit,
        "baseline_burnout": baseline_burnout,
        "treatment": treatment,
        "implementation_quality": implementation_quality,
        "post_feedback_responsiveness": post_feedback_responsiveness,
        "post_purpose_alignment": post_purpose_alignment,
        "post_recovery_capacity": post_recovery_capacity,
        "post_grit": post_grit,
        "adaptive_persistence": adaptive_persistence,
        "post_burnout": post_burnout,
    }
)

df.to_csv(PROCESSED / "can-grit-be-taught-synthetic-intervention-evaluation.csv", index=False)

descriptive = (
    df.groupby("treatment", as_index=False)
    .agg(
        n=("age", "count"),
        mean_baseline_grit=("baseline_grit", "mean"),
        mean_post_grit=("post_grit", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_baseline_burnout=("baseline_burnout", "mean"),
        mean_post_burnout=("post_burnout", "mean"),
        mean_post_recovery_capacity=("post_recovery_capacity", "mean"),
    )
)

model_post_grit = smf.ols(
    "post_grit ~ treatment + baseline_grit + baseline_support + baseline_stress + C(developmental_stage)",
    data=df,
).fit()

model_moderation = smf.ols(
    "post_grit ~ treatment * baseline_support + baseline_grit + baseline_stress + C(developmental_stage)",
    data=df,
).fit()

model_adaptive = smf.ols(
    "adaptive_persistence ~ treatment + post_grit + post_feedback_responsiveness + "
    "post_purpose_alignment + post_recovery_capacity + baseline_support + baseline_stress + "
    "C(developmental_stage)",
    data=df,
).fit()

model_burnout = smf.ols(
    "post_burnout ~ treatment + baseline_burnout + baseline_stress + "
    "post_recovery_capacity + baseline_support + C(developmental_stage)",
    data=df,
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "post_grit_intervention_effect",
            "support_moderation_model",
            "adaptive_persistence_model",
            "burnout_safety_model",
        ],
        "r_squared": [
            model_post_grit.rsquared,
            model_moderation.rsquared,
            model_adaptive.rsquared,
            model_burnout.rsquared,
        ],
        "adjusted_r_squared": [
            model_post_grit.rsquared_adj,
            model_moderation.rsquared_adj,
            model_adaptive.rsquared_adj,
            model_burnout.rsquared_adj,
        ],
    }
)

descriptive.to_csv(OUT / "can-grit-be-taught-descriptive-by-treatment.csv", index=False)
comparison.to_csv(OUT / "can-grit-be-taught-model-comparison.csv", index=False)
pd.DataFrame({"term": model_moderation.params.index, "estimate": model_moderation.params.values}).to_csv(
    OUT / "can-grit-be-taught-support-moderation-coefficients.csv", index=False
)
pd.DataFrame({"term": model_burnout.params.index, "estimate": model_burnout.params.values}).to_csv(
    OUT / "can-grit-be-taught-burnout-safety-coefficients.csv", index=False
)

print("Descriptive summary by treatment")
print(descriptive.round(3))
print("\nModel comparison")
print(comparison.round(4))
print("\nProfessional caution: synthetic intervention evaluation only.")
