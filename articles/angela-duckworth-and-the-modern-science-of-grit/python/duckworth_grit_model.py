"""
Angela Duckworth and the Modern Science of Grit

Synthetic-data workflow for modeling grit as perseverance of effort plus
consistency of interest, then comparing a grit-only model with a broader
contextual model.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "duckworth-grit-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "duckworth-grit-model-comparison-python.csv"

rng = np.random.default_rng(42)
n = 750

perseverance_effort = rng.normal(0, 1, n)
consistency_interest = rng.normal(0, 1, n)

conscientiousness = 0.60 * perseverance_effort + rng.normal(0, 0.80, n)
self_control = 0.45 * perseverance_effort + rng.normal(0, 0.90, n)
social_support = rng.normal(0, 1, n)
prior_achievement = rng.normal(0, 1, n)

grit_score = 0.60 * perseverance_effort + 0.40 * consistency_interest

achievement_outcome = (
    0.18 * grit_score
    + 0.34 * prior_achievement
    + 0.22 * conscientiousness
    + 0.15 * self_control
    + 0.25 * social_support
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interest": consistency_interest,
        "grit_score": grit_score,
        "conscientiousness": conscientiousness,
        "self_control": self_control,
        "social_support": social_support,
        "prior_achievement": prior_achievement,
        "achievement_outcome": achievement_outcome,
    }
)

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(DATA_OUT, index=False)

model_grit_only = sm.OLS(
    df["achievement_outcome"],
    sm.add_constant(df[["grit_score"]]),
).fit()

model_contextual = sm.OLS(
    df["achievement_outcome"],
    sm.add_constant(
        df[
            [
                "grit_score",
                "prior_achievement",
                "conscientiousness",
                "self_control",
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
