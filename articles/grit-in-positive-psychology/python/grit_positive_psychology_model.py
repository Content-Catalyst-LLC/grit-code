"""
Grit in Positive Psychology

Synthetic-data workflow for modeling grit as one contributor to flourishing
inside a broader positive psychology framework.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-positive-psychology-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-positive-psychology-model-comparison-python.csv"

rng = np.random.default_rng(42)
n = 800

perseverance_effort = rng.normal(0, 1, n)
durable_interest = rng.normal(0, 1, n)

meaning = rng.normal(0, 1, n)
relationships = rng.normal(0, 1, n)
social_support = 0.50 * relationships + rng.normal(0, 0.85, n)
health_resources = rng.normal(0, 1, n)
depletion = rng.normal(0, 1, n)

grit_score = 0.60 * perseverance_effort + 0.40 * durable_interest

flourishing = (
    0.18 * grit_score
    + 0.30 * meaning
    + 0.25 * relationships
    + 0.22 * social_support
    + 0.20 * health_resources
    - 0.28 * depletion
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "durable_interest": durable_interest,
        "grit_score": grit_score,
        "meaning": meaning,
        "relationships": relationships,
        "social_support": social_support,
        "health_resources": health_resources,
        "depletion": depletion,
        "flourishing": flourishing,
    }
)

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(DATA_OUT, index=False)

model_grit_only = sm.OLS(
    df["flourishing"],
    sm.add_constant(df[["grit_score"]]),
).fit()

model_positive_psychology = sm.OLS(
    df["flourishing"],
    sm.add_constant(
        df[
            [
                "grit_score",
                "meaning",
                "relationships",
                "social_support",
                "health_resources",
                "depletion",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": ["grit_only", "grit_plus_positive_psychology_context"],
        "r_squared": [model_grit_only.rsquared, model_positive_psychology.rsquared],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_positive_psychology.rsquared_adj,
        ],
        "grit_coefficient": [
            model_grit_only.params["grit_score"],
            model_positive_psychology.params["grit_score"],
        ],
        "grit_p_value": [
            model_grit_only.pvalues["grit_score"],
            model_positive_psychology.pvalues["grit_score"],
        ],
    }
)

comparison.to_csv(TABLE_OUT, index=False)

print("Saved modeled dataset:", DATA_OUT)
print("Saved model comparison:", TABLE_OUT)
print(comparison.round(4))
