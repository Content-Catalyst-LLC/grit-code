"""
Grit, Burnout, and the Risks of Overpersistence

Synthetic-data workflow for modeling burnout risk, overpersistence, and
sustainable persistence.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, admit, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-burnout-overpersistence-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-burnout-overpersistence-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-burnout-overpersistence-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-burnout-overpersistence-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

demand_intensity = rng.normal(0, 1, n)
goal_rigidity = rng.normal(0, 1, n)
identity_pressure = rng.normal(0, 1, n)
sunk_cost = rng.normal(0, 1, n)
recovery_capacity = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)
autonomy = rng.normal(0, 1, n)
feedback_responsiveness = rng.normal(0, 1, n)
goal_fit = rng.normal(0, 1, n)

overpersistence = (
    0.22 * grit
    + 0.24 * sunk_cost
    + 0.22 * identity_pressure
    + 0.20 * goal_rigidity
    - 0.22 * feedback_responsiveness
    - 0.20 * goal_fit
    + rng.normal(0, 1, n)
)

burnout_risk = (
    0.24 * demand_intensity
    + 0.22 * overpersistence
    + 0.18 * goal_rigidity
    + 0.16 * grit
    - 0.26 * recovery_capacity
    - 0.20 * social_support
    - 0.18 * autonomy
    + rng.normal(0, 1, n)
)

sustainable_persistence = (
    0.20 * grit
    + 0.24 * goal_fit
    + 0.22 * feedback_responsiveness
    + 0.20 * recovery_capacity
    + 0.18 * social_support
    + 0.18 * autonomy
    - 0.24 * burnout_risk
    - 0.16 * overpersistence
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "demand_intensity": demand_intensity,
        "goal_rigidity": goal_rigidity,
        "identity_pressure": identity_pressure,
        "sunk_cost": sunk_cost,
        "recovery_capacity": recovery_capacity,
        "social_support": social_support,
        "autonomy": autonomy,
        "feedback_responsiveness": feedback_responsiveness,
        "goal_fit": goal_fit,
        "overpersistence": overpersistence,
        "burnout_risk": burnout_risk,
        "sustainable_persistence": sustainable_persistence,
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
        "demand_intensity",
        "goal_rigidity",
        "identity_pressure",
        "sunk_cost",
        "recovery_capacity",
        "social_support",
        "autonomy",
        "feedback_responsiveness",
        "goal_fit",
        "overpersistence",
        "burnout_risk",
        "sustainable_persistence",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["burnout_risk"],
    sm.add_constant(df[["grit"]]),
).fit()

model_overpersistence = sm.OLS(
    df["burnout_risk"],
    sm.add_constant(df[["grit", "demand_intensity", "goal_rigidity", "overpersistence"]]),
).fit()

model_burnout = sm.OLS(
    df["burnout_risk"],
    sm.add_constant(
        df[
            [
                "grit",
                "demand_intensity",
                "goal_rigidity",
                "overpersistence",
                "recovery_capacity",
                "social_support",
                "autonomy",
            ]
        ]
    ),
).fit()

model_sustainable = sm.OLS(
    df["sustainable_persistence"],
    sm.add_constant(
        df[
            [
                "grit",
                "goal_fit",
                "feedback_responsiveness",
                "recovery_capacity",
                "social_support",
                "autonomy",
                "burnout_risk",
                "overpersistence",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only_burnout",
            "demand_overpersistence_burnout",
            "contextual_burnout_model",
            "sustainable_persistence_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_overpersistence.rsquared,
            model_burnout.rsquared,
            model_sustainable.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_overpersistence.rsquared_adj,
            model_burnout.rsquared_adj,
            model_sustainable.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_sustainable_persistence=("sustainable_persistence", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_overpersistence=("overpersistence", "mean"),
        mean_grit=("grit", "mean"),
        mean_recovery_capacity=("recovery_capacity", "mean"),
        mean_goal_fit=("goal_fit", "mean"),
        mean_feedback_responsiveness=("feedback_responsiveness", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_autonomy=("autonomy", "mean"),
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
