"""
Grit and Conscientiousness: Overlap, Distinction, and Debate

Synthetic-data workflow for modeling grit and conscientiousness as overlapping
but distinguishable predictors, with incremental-validity comparisons.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-conscientiousness-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-conscientiousness-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-conscientiousness-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-conscientiousness-correlations-python.csv"

rng = np.random.default_rng(42)
n = 900

industriousness = rng.normal(0, 1, n)
orderliness = rng.normal(0, 1, n)
dependability = rng.normal(0, 1, n)
responsibility = rng.normal(0, 1, n)
achievement_striving = rng.normal(0, 1, n)

conscientiousness = (
    0.30 * industriousness
    + 0.18 * orderliness
    + 0.18 * dependability
    + 0.17 * responsibility
    + 0.17 * achievement_striving
)

perseverance_effort = (
    0.55 * industriousness
    + 0.25 * achievement_striving
    + rng.normal(0, 0.85, n)
)

consistency_interests = (
    0.20 * achievement_striving
    + rng.normal(0, 1.00, n)
)

grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

prior_achievement = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)
burnout = rng.normal(0, 1, n)

long_term_progress = (
    0.24 * conscientiousness
    + 0.18 * grit
    + 0.22 * prior_achievement
    + 0.18 * social_support
    - 0.20 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "industriousness": industriousness,
        "orderliness": orderliness,
        "dependability": dependability,
        "responsibility": responsibility,
        "achievement_striving": achievement_striving,
        "conscientiousness": conscientiousness,
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "prior_achievement": prior_achievement,
        "social_support": social_support,
        "burnout": burnout,
        "long_term_progress": long_term_progress,
    }
)

c_median = df["conscientiousness"].median()
g_median = df["grit"].median()

conditions = [
    (df["conscientiousness"] >= c_median) & (df["grit"] >= g_median),
    (df["conscientiousness"] >= c_median) & (df["grit"] < g_median),
    (df["conscientiousness"] < c_median) & (df["grit"] >= g_median),
    (df["conscientiousness"] < c_median) & (df["grit"] < g_median),
]
choices = [
    "high_conscientiousness_high_grit",
    "high_conscientiousness_low_grit",
    "low_conscientiousness_high_grit",
    "low_conscientiousness_low_grit",
]
df["profile"] = np.select(conditions, choices, default="unclassified")

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
PROFILE_OUT.parent.mkdir(parents=True, exist_ok=True)
CORR_OUT.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(DATA_OUT, index=False)

correlations = df[
    [
        "conscientiousness",
        "grit",
        "perseverance_effort",
        "consistency_interests",
        "industriousness",
        "achievement_striving",
        "long_term_progress",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_conscientiousness = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(df[["conscientiousness"]]),
).fit()

model_grit = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(df[["grit"]]),
).fit()

model_combined = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(df[["conscientiousness", "grit"]]),
).fit()

model_facets = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(
        df[
            [
                "conscientiousness",
                "perseverance_effort",
                "consistency_interests",
            ]
        ]
    ),
).fit()

model_contextual = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(
        df[
            [
                "conscientiousness",
                "perseverance_effort",
                "consistency_interests",
                "prior_achievement",
                "social_support",
                "burnout",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "conscientiousness_only",
            "grit_only",
            "conscientiousness_plus_grit",
            "conscientiousness_plus_grit_facets",
            "contextual_model",
        ],
        "r_squared": [
            model_conscientiousness.rsquared,
            model_grit.rsquared,
            model_combined.rsquared,
            model_facets.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_conscientiousness.rsquared_adj,
            model_grit.rsquared_adj,
            model_combined.rsquared_adj,
            model_facets.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_conscientiousness=("conscientiousness", "mean"),
        mean_grit=("grit", "mean"),
        mean_perseverance_effort=("perseverance_effort", "mean"),
        mean_consistency_interests=("consistency_interests", "mean"),
        mean_long_term_progress=("long_term_progress", "mean"),
        mean_burnout=("burnout", "mean"),
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
