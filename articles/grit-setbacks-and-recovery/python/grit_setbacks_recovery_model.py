"""
Grit, Setbacks, and Recovery

Synthetic-data workflow for modeling adaptive persistence after setbacks as a
recovery system.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, admit, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-setbacks-recovery-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-setbacks-recovery-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-setbacks-recovery-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-setbacks-recovery-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

setback_severity = rng.normal(0, 1, n)
emotional_recovery = rng.normal(0, 1, n)
cognitive_recovery = rng.normal(0, 1, n)
physical_restoration = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)
practical_resources = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
opportunity_access = rng.normal(0, 1, n)

recovery_capacity = (
    0.22 * emotional_recovery
    + 0.22 * cognitive_recovery
    + 0.18 * physical_restoration
    + 0.20 * social_support
    + 0.18 * practical_resources
)

burnout = (
    0.24 * setback_severity
    + 0.18 * grit
    - 0.24 * recovery_capacity
    - 0.20 * social_support
    + rng.normal(0, 1, n)
)

grit_recovery_interaction = grit * recovery_capacity

adaptive_persistence = (
    0.18 * grit
    - 0.22 * setback_severity
    + 0.28 * recovery_capacity
    + 0.12 * grit_recovery_interaction
    + 0.18 * feedback_quality
    + 0.18 * opportunity_access
    + 0.14 * social_support
    - 0.20 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "setback_severity": setback_severity,
        "emotional_recovery": emotional_recovery,
        "cognitive_recovery": cognitive_recovery,
        "physical_restoration": physical_restoration,
        "social_support": social_support,
        "practical_resources": practical_resources,
        "feedback_quality": feedback_quality,
        "opportunity_access": opportunity_access,
        "recovery_capacity": recovery_capacity,
        "burnout": burnout,
        "grit_recovery_interaction": grit_recovery_interaction,
        "adaptive_persistence": adaptive_persistence,
    }
)

grit_median = df["grit"].median()
recovery_median = df["recovery_capacity"].median()

conditions = [
    (df["grit"] >= grit_median) & (df["recovery_capacity"] >= recovery_median),
    (df["grit"] >= grit_median) & (df["recovery_capacity"] < recovery_median),
    (df["grit"] < grit_median) & (df["recovery_capacity"] >= recovery_median),
    (df["grit"] < grit_median) & (df["recovery_capacity"] < recovery_median),
]
choices = [
    "high_grit_high_recovery",
    "high_grit_low_recovery",
    "low_grit_high_recovery",
    "low_grit_low_recovery",
]
df["profile"] = np.select(conditions, choices, default="unclassified")

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
PROFILE_OUT.parent.mkdir(parents=True, exist_ok=True)
CORR_OUT.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(DATA_OUT, index=False)

correlations = df[
    [
        "grit",
        "setback_severity",
        "recovery_capacity",
        "social_support",
        "feedback_quality",
        "opportunity_access",
        "burnout",
        "adaptive_persistence",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["adaptive_persistence"],
    sm.add_constant(df[["grit"]]),
).fit()

model_recovery = sm.OLS(
    df["adaptive_persistence"],
    sm.add_constant(df[["grit", "setback_severity", "recovery_capacity"]]),
).fit()

model_interaction = sm.OLS(
    df["adaptive_persistence"],
    sm.add_constant(
        df[[
            "grit",
            "setback_severity",
            "recovery_capacity",
            "grit_recovery_interaction",
        ]]
    ),
).fit()

model_contextual = sm.OLS(
    df["adaptive_persistence"],
    sm.add_constant(
        df[[
            "grit",
            "setback_severity",
            "recovery_capacity",
            "grit_recovery_interaction",
            "social_support",
            "feedback_quality",
            "opportunity_access",
            "burnout",
        ]]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only",
            "grit_setback_recovery",
            "grit_recovery_interaction",
            "contextual_recovery_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_recovery.rsquared,
            model_interaction.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_recovery.rsquared_adj,
            model_interaction.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_grit=("grit", "mean"),
        mean_setback_severity=("setback_severity", "mean"),
        mean_recovery_capacity=("recovery_capacity", "mean"),
        mean_emotional_recovery=("emotional_recovery", "mean"),
        mean_cognitive_recovery=("cognitive_recovery", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_feedback_quality=("feedback_quality", "mean"),
        mean_burnout=("burnout", "mean"),
    )
)

comparison.to_csv(TABLE_OUT, index=False)
profile_summary.to_csv(PROFILE_OUT, index=False)

print("Saved modeled dataset:", DATA_OUT)
print("Saved correlations:", CORR_OUT)
print("Saved model comparison:", TABLE_OUT)
print("Saved profile summary:", PROFILE_OUT)
print(comparison.round(4))
print(profile_summary.round(4))
