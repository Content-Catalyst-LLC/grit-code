"""
What Is Grit? — Python synthetic-data workflow

This script models grit as a combination of perseverance of effort and
consistency of interest, then compares a grit-only model with a model that
also includes prior achievement, conscientiousness, and social support.

The data are synthetic and are intended for article support and methods
demonstration only.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "what-is-grit-modeled-data.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "what-is-grit-regression-summary.csv"

rng = np.random.default_rng(42)
n = 500

perseverance_effort = rng.normal(0, 1, n)
consistency_interest = rng.normal(0, 1, n)
conscientiousness = 0.55 * perseverance_effort + rng.normal(0, 0.85, n)
social_support = rng.normal(0, 1, n)
prior_achievement = rng.normal(0, 1, n)

grit_score = 0.60 * perseverance_effort + 0.40 * consistency_interest

achievement_outcome = (
    0.25 * grit_score
    + 0.35 * prior_achievement
    + 0.20 * conscientiousness
    + 0.25 * social_support
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interest": consistency_interest,
        "grit_score": grit_score,
        "conscientiousness": conscientiousness,
        "social_support": social_support,
        "prior_achievement": prior_achievement,
        "achievement_outcome": achievement_outcome,
    }
)

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(DATA_OUT, index=False)

model_1 = sm.OLS(df["achievement_outcome"], sm.add_constant(df[["grit_score"]])).fit()

model_2 = sm.OLS(
    df["achievement_outcome"],
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

summary = pd.DataFrame(
    {
        "model": ["grit_only", "grit_plus_controls"],
        "r_squared": [model_1.rsquared, model_2.rsquared],
        "adjusted_r_squared": [model_1.rsquared_adj, model_2.rsquared_adj],
        "grit_coefficient": [
            model_1.params.get("grit_score"),
            model_2.params.get("grit_score"),
        ],
        "grit_p_value": [
            model_1.pvalues.get("grit_score"),
            model_2.pvalues.get("grit_score"),
        ],
    }
)

summary.to_csv(TABLE_OUT, index=False)

print("Saved modeled dataset to:", DATA_OUT)
print("Saved regression summary to:", TABLE_OUT)
print(summary)
