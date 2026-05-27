"""
Perseverance of Effort Versus Consistency of Interests

Synthetic-data workflow for modeling grit facets separately, comparing total
grit with facet-level models, and interpreting outcomes with context.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-facet-comparison-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-facet-comparison-models-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-facet-profile-summary-python.csv"

rng = np.random.default_rng(42)
n = 900

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)

conscientiousness = 0.62 * perseverance_effort + rng.normal(0, 0.80, n)
self_control = 0.45 * perseverance_effort + rng.normal(0, 0.90, n)
social_support = rng.normal(0, 1, n)
prior_achievement = rng.normal(0, 1, n)
burnout = rng.normal(0, 1, n)

grit_total = 0.60 * perseverance_effort + 0.40 * consistency_interests

long_term_outcome = (
    0.28 * perseverance_effort
    + 0.08 * consistency_interests
    + 0.25 * prior_achievement
    + 0.18 * conscientiousness
    + 0.20 * social_support
    - 0.22 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit_total": grit_total,
        "conscientiousness": conscientiousness,
        "self_control": self_control,
        "social_support": social_support,
        "prior_achievement": prior_achievement,
        "burnout": burnout,
        "long_term_outcome": long_term_outcome,
    }
)

pe_median = df["perseverance_effort"].median()
ci_median = df["consistency_interests"].median()

conditions = [
    (df["perseverance_effort"] >= pe_median) & (df["consistency_interests"] >= ci_median),
    (df["perseverance_effort"] >= pe_median) & (df["consistency_interests"] < ci_median),
    (df["perseverance_effort"] < pe_median) & (df["consistency_interests"] >= ci_median),
    (df["perseverance_effort"] < pe_median) & (df["consistency_interests"] < ci_median),
]
choices = [
    "high_effort_high_consistency",
    "high_effort_low_consistency",
    "low_effort_high_consistency",
    "low_effort_low_consistency",
]
df["facet_profile"] = np.select(conditions, choices, default="unclassified")

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
PROFILE_OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(DATA_OUT, index=False)

model_total_grit = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(df[["grit_total"]]),
).fit()

model_facets = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(df[["perseverance_effort", "consistency_interests"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_outcome"],
    sm.add_constant(
        df[
            [
                "perseverance_effort",
                "consistency_interests",
                "prior_achievement",
                "conscientiousness",
                "self_control",
                "social_support",
                "burnout",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": ["total_grit_only", "facets_only", "facets_plus_context"],
        "r_squared": [
            model_total_grit.rsquared,
            model_facets.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_total_grit.rsquared_adj,
            model_facets.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("facet_profile", as_index=False)
    .agg(
        n=("facet_profile", "size"),
        mean_perseverance_effort=("perseverance_effort", "mean"),
        mean_consistency_interests=("consistency_interests", "mean"),
        mean_long_term_outcome=("long_term_outcome", "mean"),
        mean_burnout=("burnout", "mean"),
        mean_social_support=("social_support", "mean"),
    )
)

comparison.to_csv(TABLE_OUT, index=False)
profile_summary.to_csv(PROFILE_OUT, index=False)

print("Saved modeled dataset:", DATA_OUT)
print("Saved model comparison:", TABLE_OUT)
print("Saved profile summary:", PROFILE_OUT)
print(comparison.round(4))
print(profile_summary.round(4))
