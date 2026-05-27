"""
When Quitting Is Adaptive

Synthetic-data workflow for modeling adaptive quitting, goal disengagement,
goal reengagement, overpersistence risk, and sustainable persistence.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, admit, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "when-quitting-is-adaptive-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "when-quitting-is-adaptive-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "when-quitting-is-adaptive-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "when-quitting-is-adaptive-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

cumulative_cost = rng.normal(0, 1, n)
health_risk = rng.normal(0, 1, n)
goal_misalignment = rng.normal(0, 1, n)
opportunity_cost = rng.normal(0, 1, n)

future_value = rng.normal(0, 1, n)
learning_potential = rng.normal(0, 1, n)
purpose_alignment = rng.normal(0, 1, n)

social_support = rng.normal(0, 1, n)
financial_security = rng.normal(0, 1, n)
feedback_responsiveness = rng.normal(0, 1, n)
sunk_cost = rng.normal(0, 1, n)
identity_pressure = rng.normal(0, 1, n)

alternative_meaning = rng.normal(0, 1, n)
alternative_feasibility = rng.normal(0, 1, n)
alternative_support = rng.normal(0, 1, n)
transition_cost = rng.normal(0, 1, n)

alternative_goal_value = (
    0.30 * alternative_meaning
    + 0.28 * alternative_feasibility
    + 0.24 * alternative_support
    - 0.18 * transition_cost
)

quitting_pressure = (
    0.24 * cumulative_cost
    + 0.26 * health_risk
    + 0.24 * goal_misalignment
    + 0.20 * opportunity_cost
    - 0.24 * future_value
    - 0.20 * learning_potential
    - 0.24 * purpose_alignment
)

overpersistence_risk = (
    0.18 * grit
    + 0.24 * sunk_cost
    + 0.24 * identity_pressure
    - 0.24 * feedback_responsiveness
    - 0.22 * purpose_alignment
    + rng.normal(0, 1, n)
)

adaptive_quitting_readiness = (
    0.28 * quitting_pressure
    + 0.26 * alternative_goal_value
    + 0.18 * social_support
    + 0.16 * financial_security
    + 0.16 * feedback_responsiveness
    - 0.20 * overpersistence_risk
    + rng.normal(0, 1, n)
)

sustainable_persistence = (
    0.20 * grit
    + 0.26 * purpose_alignment
    + 0.22 * future_value
    + 0.20 * learning_potential
    + 0.18 * feedback_responsiveness
    + 0.16 * social_support
    - 0.26 * quitting_pressure
    - 0.18 * health_risk
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "cumulative_cost": cumulative_cost,
        "health_risk": health_risk,
        "goal_misalignment": goal_misalignment,
        "opportunity_cost": opportunity_cost,
        "future_value": future_value,
        "learning_potential": learning_potential,
        "purpose_alignment": purpose_alignment,
        "social_support": social_support,
        "financial_security": financial_security,
        "feedback_responsiveness": feedback_responsiveness,
        "sunk_cost": sunk_cost,
        "identity_pressure": identity_pressure,
        "alternative_meaning": alternative_meaning,
        "alternative_feasibility": alternative_feasibility,
        "alternative_support": alternative_support,
        "transition_cost": transition_cost,
        "alternative_goal_value": alternative_goal_value,
        "quitting_pressure": quitting_pressure,
        "overpersistence_risk": overpersistence_risk,
        "adaptive_quitting_readiness": adaptive_quitting_readiness,
        "sustainable_persistence": sustainable_persistence,
    }
)

pressure_median = df["quitting_pressure"].median()
alternative_median = df["alternative_goal_value"].median()

conditions = [
    (df["quitting_pressure"] >= pressure_median) & (df["alternative_goal_value"] >= alternative_median),
    (df["quitting_pressure"] >= pressure_median) & (df["alternative_goal_value"] < alternative_median),
    (df["quitting_pressure"] < pressure_median) & (df["alternative_goal_value"] >= alternative_median),
    (df["quitting_pressure"] < pressure_median) & (df["alternative_goal_value"] < alternative_median),
]
choices = [
    "high_pressure_high_alternative",
    "high_pressure_low_alternative",
    "low_pressure_high_alternative",
    "low_pressure_low_alternative",
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
        "quitting_pressure",
        "alternative_goal_value",
        "overpersistence_risk",
        "purpose_alignment",
        "feedback_responsiveness",
        "health_risk",
        "adaptive_quitting_readiness",
        "sustainable_persistence",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["adaptive_quitting_readiness"],
    sm.add_constant(df[["grit"]]),
).fit()

model_decision = sm.OLS(
    df["adaptive_quitting_readiness"],
    sm.add_constant(
        df[[
            "quitting_pressure",
            "alternative_goal_value",
            "social_support",
            "financial_security",
        ]]
    ),
).fit()

model_overpersistence = sm.OLS(
    df["overpersistence_risk"],
    sm.add_constant(
        df[[
            "grit",
            "sunk_cost",
            "identity_pressure",
            "feedback_responsiveness",
            "purpose_alignment",
        ]]
    ),
).fit()

model_sustainable = sm.OLS(
    df["sustainable_persistence"],
    sm.add_constant(
        df[[
            "grit",
            "purpose_alignment",
            "future_value",
            "learning_potential",
            "feedback_responsiveness",
            "social_support",
            "quitting_pressure",
            "health_risk",
        ]]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only_adaptive_quitting",
            "decision_context_adaptive_quitting",
            "overpersistence_risk_model",
            "sustainable_persistence_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_decision.rsquared,
            model_overpersistence.rsquared,
            model_sustainable.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_decision.rsquared_adj,
            model_overpersistence.rsquared_adj,
            model_sustainable.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_adaptive_quitting_readiness=("adaptive_quitting_readiness", "mean"),
        mean_sustainable_persistence=("sustainable_persistence", "mean"),
        mean_overpersistence_risk=("overpersistence_risk", "mean"),
        mean_grit=("grit", "mean"),
        mean_quitting_pressure=("quitting_pressure", "mean"),
        mean_alternative_goal_value=("alternative_goal_value", "mean"),
        mean_purpose_alignment=("purpose_alignment", "mean"),
        mean_health_risk=("health_risk", "mean"),
        mean_feedback_responsiveness=("feedback_responsiveness", "mean"),
        mean_social_support=("social_support", "mean"),
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
