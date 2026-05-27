"""
Grit and Deliberate Practice

Synthetic-data workflow for modeling grit, deliberate practice, feedback,
coaching, prior skill, burnout, and performance.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-deliberate-practice-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-deliberate-practice-model-comparison-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-deliberate-practice-correlations-python.csv"

rng = np.random.default_rng(42)
n = 900

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

feedback_quality = rng.normal(0, 1, n)
coaching_access = rng.normal(0, 1, n)
prior_skill = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)

deliberate_practice = (
    0.35 * grit
    + 0.28 * feedback_quality
    + 0.22 * coaching_access
    + 0.15 * social_support
    + rng.normal(0, 1, n)
)

burnout = (
    0.20 * deliberate_practice
    - 0.25 * social_support
    - 0.20 * feedback_quality
    + rng.normal(0, 1, n)
)

performance = (
    0.16 * grit
    + 0.34 * deliberate_practice
    + 0.28 * prior_skill
    + 0.18 * feedback_quality
    + 0.16 * coaching_access
    + 0.14 * social_support
    - 0.18 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "feedback_quality": feedback_quality,
        "coaching_access": coaching_access,
        "prior_skill": prior_skill,
        "social_support": social_support,
        "deliberate_practice": deliberate_practice,
        "burnout": burnout,
        "performance": performance,
    }
)

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
CORR_OUT.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(DATA_OUT, index=False)

correlations = df[
    [
        "grit",
        "deliberate_practice",
        "feedback_quality",
        "coaching_access",
        "prior_skill",
        "social_support",
        "burnout",
        "performance",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["performance"],
    sm.add_constant(df[["grit"]]),
).fit()

model_practice_only = sm.OLS(
    df["performance"],
    sm.add_constant(df[["deliberate_practice"]]),
).fit()

model_grit_practice = sm.OLS(
    df["performance"],
    sm.add_constant(df[["grit", "deliberate_practice"]]),
).fit()

model_contextual = sm.OLS(
    df["performance"],
    sm.add_constant(
        df[
            [
                "grit",
                "deliberate_practice",
                "prior_skill",
                "feedback_quality",
                "coaching_access",
                "social_support",
                "burnout",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only",
            "deliberate_practice_only",
            "grit_plus_deliberate_practice",
            "contextual_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_practice_only.rsquared,
            model_grit_practice.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_practice_only.rsquared_adj,
            model_grit_practice.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

comparison.to_csv(TABLE_OUT, index=False)

print("Saved modeled dataset:", DATA_OUT)
print("Saved correlations:", CORR_OUT)
print("Saved model comparison:", TABLE_OUT)
print(comparison.round(4))
print(correlations.round(3))
