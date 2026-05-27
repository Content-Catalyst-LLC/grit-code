"""
Grit and Academic Persistence

Synthetic-data workflow for modeling academic persistence as a developmental
and contextual process.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, admit, discipline, or evaluate real students.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-academic-persistence-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-academic-persistence-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-academic-persistence-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-academic-persistence-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

self_control = rng.normal(0, 1, n)
prior_preparation = rng.normal(0, 1, n)
instructional_quality = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
belonging = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)
financial_stress = rng.normal(0, 1, n)
health_stability = rng.normal(0, 1, n)

study_effort = (
    0.30 * grit
    + 0.26 * self_control
    + 0.18 * belonging
    + 0.16 * social_support
    - 0.18 * financial_stress
    + rng.normal(0, 1, n)
)

burnout = (
    0.22 * financial_stress
    + 0.18 * study_effort
    - 0.22 * social_support
    - 0.20 * health_stability
    - 0.16 * belonging
    + rng.normal(0, 1, n)
)

academic_progress = (
    0.18 * grit
    + 0.24 * study_effort
    + 0.26 * prior_preparation
    + 0.20 * instructional_quality
    + 0.18 * feedback_quality
    + 0.18 * belonging
    + 0.14 * social_support
    - 0.18 * burnout
    + rng.normal(0, 1, n)
)

academic_persistence = (
    0.20 * grit
    + 0.18 * self_control
    + 0.24 * academic_progress
    + 0.22 * belonging
    + 0.18 * social_support
    - 0.20 * financial_stress
    - 0.18 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "self_control": self_control,
        "prior_preparation": prior_preparation,
        "instructional_quality": instructional_quality,
        "feedback_quality": feedback_quality,
        "belonging": belonging,
        "social_support": social_support,
        "financial_stress": financial_stress,
        "health_stability": health_stability,
        "study_effort": study_effort,
        "burnout": burnout,
        "academic_progress": academic_progress,
        "academic_persistence": academic_persistence,
    }
)

grit_median = df["grit"].median()
belonging_median = df["belonging"].median()

conditions = [
    (df["grit"] >= grit_median) & (df["belonging"] >= belonging_median),
    (df["grit"] >= grit_median) & (df["belonging"] < belonging_median),
    (df["grit"] < grit_median) & (df["belonging"] >= belonging_median),
    (df["grit"] < grit_median) & (df["belonging"] < belonging_median),
]
choices = [
    "high_grit_high_belonging",
    "high_grit_low_belonging",
    "low_grit_high_belonging",
    "low_grit_low_belonging",
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
        "self_control",
        "prior_preparation",
        "instructional_quality",
        "feedback_quality",
        "belonging",
        "social_support",
        "financial_stress",
        "burnout",
        "academic_progress",
        "academic_persistence",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["academic_persistence"],
    sm.add_constant(df[["grit"]]),
).fit()

model_regulation = sm.OLS(
    df["academic_persistence"],
    sm.add_constant(df[["grit", "self_control", "study_effort", "academic_progress"]]),
).fit()

model_contextual = sm.OLS(
    df["academic_persistence"],
    sm.add_constant(
        df[
            [
                "grit",
                "self_control",
                "prior_preparation",
                "instructional_quality",
                "feedback_quality",
                "belonging",
                "social_support",
                "financial_stress",
                "health_stability",
                "study_effort",
                "burnout",
                "academic_progress",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only",
            "grit_self_control_study_progress",
            "contextual_persistence_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_regulation.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_regulation.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_academic_persistence=("academic_persistence", "mean"),
        mean_academic_progress=("academic_progress", "mean"),
        mean_grit=("grit", "mean"),
        mean_belonging=("belonging", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_financial_stress=("financial_stress", "mean"),
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
