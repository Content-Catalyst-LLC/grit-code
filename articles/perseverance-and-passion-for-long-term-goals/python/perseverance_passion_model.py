"""
Perseverance and Passion for Long-Term Goals

Synthetic-data workflow for modeling grit as perseverance of effort plus
durable passion / consistency of interest, then comparing a grit-only model
with a broader contextual model.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "perseverance-passion-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "perseverance-passion-model-comparison-python.csv"

rng = np.random.default_rng(42)
n = 700

perseverance_effort = rng.normal(0, 1, n)
durable_passion = rng.normal(0, 1, n)

conscientiousness = 0.55 * perseverance_effort + rng.normal(0, 0.85, n)
social_support = rng.normal(0, 1, n)
prior_achievement = rng.normal(0, 1, n)

grit_score = 0.60 * perseverance_effort + 0.40 * durable_passion

long_term_outcome = (
    0.22 * grit_score
    + 0.34 * prior_achievement
    + 0.24 * conscientiousness
    + 0.26 * social_support
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "durable_passion": durable_passion,
        "grit_score": grit_score,
        "conscientiousness": conscientiousness,
        "social_support": social_support,
        "prior_achievement": prior_achievement,
        "long_term_outcome": long_term_outcome,
    }
)

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(DATA_OUT, index=False)

model_grit_only = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(df[["grit_score"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(
        df[
            [
                "grit_score",
                "prior_achievement",
                "conscientiousness",
                "social_support",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": ["grit_only", "grit_plus_controls"],
        "r_squared": [model_grit_only.rsquared, model_contextual.rsquared],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
        "grit_coefficient": [
            model_grit_only.params["grit_score"],
            model_contextual.params["grit_score"],
        ],
        "grit_p_value": [
            model_grit_only.pvalues["grit_score"],
            model_contextual.pvalues["grit_score"],
        ],
    }
)

comparison.to_csv(TABLE_OUT, index=False)

print("Saved modeled dataset:", DATA_OUT)
print("Saved model comparison:", TABLE_OUT)
print(comparison.round(4))
