"""
Grit and Long-Term Achievement

Synthetic-data workflow for modeling grit and long-term achievement as a
developmental and contextual process.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-long-term-achievement-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-long-term-achievement-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-long-term-achievement-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-long-term-achievement-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

prior_preparation = rng.normal(0, 1, n)
deliberate_practice = 0.35 * grit + 0.25 * prior_preparation + rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)
opportunity_access = rng.normal(0, 1, n)
health_stability = rng.normal(0, 1, n)

burnout = (
    0.20 * grit
    + 0.18 * deliberate_practice
    - 0.25 * social_support
    - 0.20 * health_stability
    + rng.normal(0, 1, n)
)

long_term_achievement = (
    0.16 * grit
    + 0.30 * deliberate_practice
    + 0.26 * prior_preparation
    + 0.18 * feedback_quality
    + 0.20 * social_support
    + 0.24 * opportunity_access
    + 0.14 * health_stability
    - 0.18 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "prior_preparation": prior_preparation,
        "deliberate_practice": deliberate_practice,
        "feedback_quality": feedback_quality,
        "social_support": social_support,
        "opportunity_access": opportunity_access,
        "health_stability": health_stability,
        "burnout": burnout,
        "long_term_achievement": long_term_achievement,
    }
)

grit_median = df["grit"].median()
opportunity_median = df["opportunity_access"].median()

conditions = [
    (df["grit"] >= grit_median) & (df["opportunity_access"] >= opportunity_median),
    (df["grit"] >= grit_median) & (df["opportunity_access"] < opportunity_median),
    (df["grit"] < grit_median) & (df["opportunity_access"] >= opportunity_median),
    (df["grit"] < grit_median) & (df["opportunity_access"] < opportunity_median),
]
choices = [
    "high_grit_high_opportunity",
    "high_grit_low_opportunity",
    "low_grit_high_opportunity",
    "low_grit_low_opportunity",
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
        "deliberate_practice",
        "prior_preparation",
        "feedback_quality",
        "social_support",
        "opportunity_access",
        "health_stability",
        "burnout",
        "long_term_achievement",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["long_term_achievement"],
    sm.add_constant(df[["grit"]]),
).fit()

model_practice = sm.OLS(
    df["long_term_achievement"],
    sm.add_constant(df[["grit", "deliberate_practice", "prior_preparation"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_achievement"],
    sm.add_constant(
        df[
            [
                "grit",
                "deliberate_practice",
                "prior_preparation",
                "feedback_quality",
                "social_support",
                "opportunity_access",
                "health_stability",
                "burnout",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only",
            "grit_practice_preparation",
            "contextual_achievement_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_practice.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_practice.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_grit=("grit", "mean"),
        mean_deliberate_practice=("deliberate_practice", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_opportunity_access=("opportunity_access", "mean"),
        mean_health_stability=("health_stability", "mean"),
        mean_burnout=("burnout", "mean"),
        mean_long_term_achievement=("long_term_achievement", "mean"),
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
