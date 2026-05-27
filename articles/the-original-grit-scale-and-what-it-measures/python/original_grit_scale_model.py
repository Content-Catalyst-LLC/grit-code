"""
The Original Grit Scale and What It Measures

Synthetic-data workflow for modeling grit dimensions, observed-score
interpretation, measurement error, and contextual outcome analysis.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
It does not reproduce copyrighted scale items.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "original-grit-scale-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "original-grit-scale-model-comparison-python.csv"

rng = np.random.default_rng(42)
n = 900

perseverance_effort = rng.normal(0, 1, n)
consistency_interest = rng.normal(0, 1, n)

conscientiousness = 0.60 * perseverance_effort + rng.normal(0, 0.80, n)
social_support = rng.normal(0, 1, n)
prior_achievement = rng.normal(0, 1, n)

true_grit = 0.60 * perseverance_effort + 0.40 * consistency_interest
measurement_error = rng.normal(0, 0.30, n)
observed_grit_score = true_grit + measurement_error

long_term_outcome = (
    0.20 * observed_grit_score
    + 0.34 * prior_achievement
    + 0.24 * conscientiousness
    + 0.25 * social_support
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interest": consistency_interest,
        "true_grit": true_grit,
        "observed_grit_score": observed_grit_score,
        "measurement_error": measurement_error,
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
    sm.add_constant(df[["observed_grit_score"]]),
).fit()

model_facets = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(df[["perseverance_effort", "consistency_interest"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(
        df[
            [
                "observed_grit_score",
                "prior_achievement",
                "conscientiousness",
                "social_support",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "observed_grit_only",
            "facets_only",
            "observed_grit_plus_controls",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_facets.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_facets.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

comparison.to_csv(TABLE_OUT, index=False)

print("Saved modeled dataset:", DATA_OUT)
print("Saved model comparison:", TABLE_OUT)
print(comparison.round(4))
