"""
Grit and Purpose

Synthetic-data workflow for modeling grit, purpose, support, feedback,
autonomy, opportunity, burnout, and long-term persistence.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, admit, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-purpose-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-purpose-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-purpose-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-purpose-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

personal_meaning = rng.normal(0, 1, n)
long_term_direction = rng.normal(0, 1, n)
beyond_self_contribution = rng.normal(0, 1, n)

purpose = (
    0.34 * personal_meaning
    + 0.33 * long_term_direction
    + 0.33 * beyond_self_contribution
)

social_support = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
opportunity_access = rng.normal(0, 1, n)
autonomy_support = rng.normal(0, 1, n)
health_stability = rng.normal(0, 1, n)

burnout = (
    0.18 * grit
    + 0.16 * purpose
    - 0.24 * social_support
    - 0.22 * autonomy_support
    - 0.20 * health_stability
    + rng.normal(0, 1, n)
)

grit_purpose_interaction = grit * purpose

long_term_persistence = (
    0.20 * grit
    + 0.26 * purpose
    + 0.12 * grit_purpose_interaction
    + 0.18 * social_support
    + 0.16 * feedback_quality
    + 0.18 * opportunity_access
    + 0.16 * autonomy_support
    - 0.20 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "personal_meaning": personal_meaning,
        "long_term_direction": long_term_direction,
        "beyond_self_contribution": beyond_self_contribution,
        "purpose": purpose,
        "social_support": social_support,
        "feedback_quality": feedback_quality,
        "opportunity_access": opportunity_access,
        "autonomy_support": autonomy_support,
        "health_stability": health_stability,
        "burnout": burnout,
        "grit_purpose_interaction": grit_purpose_interaction,
        "long_term_persistence": long_term_persistence,
    }
)

grit_median = df["grit"].median()
purpose_median = df["purpose"].median()

conditions = [
    (df["grit"] >= grit_median) & (df["purpose"] >= purpose_median),
    (df["grit"] >= grit_median) & (df["purpose"] < purpose_median),
    (df["grit"] < grit_median) & (df["purpose"] >= purpose_median),
    (df["grit"] < grit_median) & (df["purpose"] < purpose_median),
]
choices = [
    "high_grit_high_purpose",
    "high_grit_low_purpose",
    "low_grit_high_purpose",
    "low_grit_low_purpose",
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
        "purpose",
        "social_support",
        "feedback_quality",
        "opportunity_access",
        "autonomy_support",
        "health_stability",
        "burnout",
        "long_term_persistence",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(df[["grit"]]),
).fit()

model_grit_purpose = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(df[["grit", "purpose"]]),
).fit()

model_interaction = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(df[["grit", "purpose", "grit_purpose_interaction"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(
        df[
            [
                "grit",
                "purpose",
                "grit_purpose_interaction",
                "social_support",
                "feedback_quality",
                "opportunity_access",
                "autonomy_support",
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
            "grit_plus_purpose",
            "grit_purpose_interaction",
            "contextual_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_grit_purpose.rsquared,
            model_interaction.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_grit_purpose.rsquared_adj,
            model_interaction.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_long_term_persistence=("long_term_persistence", "mean"),
        mean_grit=("grit", "mean"),
        mean_purpose=("purpose", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_opportunity_access=("opportunity_access", "mean"),
        mean_autonomy_support=("autonomy_support", "mean"),
        mean_health_stability=("health_stability", "mean"),
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
