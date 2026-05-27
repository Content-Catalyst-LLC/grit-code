"""
Grit and Narrative Identity

Synthetic-data workflow for modeling grit, narrative identity, support,
feedback, institutional trust, burnout, narrative strain, and long-term persistence.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, admit, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-narrative-identity-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-narrative-identity-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-narrative-identity-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-narrative-identity-correlations-python.csv"

rng = np.random.default_rng(42)
n = 1000

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

narrative_coherence = rng.normal(0, 1, n)
agency = rng.normal(0, 1, n)
meaning_making = rng.normal(0, 1, n)
future_orientation = rng.normal(0, 1, n)

narrative_identity = (
    0.28 * narrative_coherence
    + 0.26 * agency
    + 0.24 * meaning_making
    + 0.22 * future_orientation
)

social_support = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
opportunity_access = rng.normal(0, 1, n)
health_stability = rng.normal(0, 1, n)
institutional_trust = rng.normal(0, 1, n)

burnout = (
    0.18 * grit
    - 0.22 * social_support
    - 0.20 * health_stability
    - 0.16 * institutional_trust
    + rng.normal(0, 1, n)
)

narrative_strain = (
    0.22 * burnout
    - 0.24 * social_support
    - 0.20 * institutional_trust
    - 0.18 * agency
    + rng.normal(0, 1, n)
)

grit_narrative_interaction = grit * narrative_identity

long_term_persistence = (
    0.18 * grit
    + 0.24 * narrative_identity
    + 0.12 * grit_narrative_interaction
    + 0.18 * social_support
    + 0.16 * feedback_quality
    + 0.18 * opportunity_access
    + 0.14 * institutional_trust
    - 0.18 * burnout
    - 0.10 * narrative_strain
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "narrative_coherence": narrative_coherence,
        "agency": agency,
        "meaning_making": meaning_making,
        "future_orientation": future_orientation,
        "narrative_identity": narrative_identity,
        "social_support": social_support,
        "feedback_quality": feedback_quality,
        "opportunity_access": opportunity_access,
        "health_stability": health_stability,
        "institutional_trust": institutional_trust,
        "burnout": burnout,
        "narrative_strain": narrative_strain,
        "grit_narrative_interaction": grit_narrative_interaction,
        "long_term_persistence": long_term_persistence,
    }
)

grit_median = df["grit"].median()
narrative_median = df["narrative_identity"].median()

conditions = [
    (df["grit"] >= grit_median) & (df["narrative_identity"] >= narrative_median),
    (df["grit"] >= grit_median) & (df["narrative_identity"] < narrative_median),
    (df["grit"] < grit_median) & (df["narrative_identity"] >= narrative_median),
    (df["grit"] < grit_median) & (df["narrative_identity"] < narrative_median),
]
choices = [
    "high_grit_high_narrative_identity",
    "high_grit_low_narrative_identity",
    "low_grit_high_narrative_identity",
    "low_grit_low_narrative_identity",
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
        "narrative_identity",
        "agency",
        "meaning_making",
        "future_orientation",
        "social_support",
        "institutional_trust",
        "burnout",
        "narrative_strain",
        "long_term_persistence",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(df[["grit"]]),
).fit()

model_grit_narrative = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(df[["grit", "narrative_identity"]]),
).fit()

model_interaction = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(df[["grit", "narrative_identity", "grit_narrative_interaction"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_persistence"],
    sm.add_constant(
        df[
            [
                "grit",
                "narrative_identity",
                "grit_narrative_interaction",
                "social_support",
                "feedback_quality",
                "opportunity_access",
                "health_stability",
                "institutional_trust",
                "burnout",
                "narrative_strain",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only",
            "grit_plus_narrative_identity",
            "grit_narrative_interaction",
            "contextual_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_grit_narrative.rsquared,
            model_interaction.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_grit_narrative.rsquared_adj,
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
        mean_narrative_identity=("narrative_identity", "mean"),
        mean_agency=("agency", "mean"),
        mean_meaning_making=("meaning_making", "mean"),
        mean_future_orientation=("future_orientation", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_institutional_trust=("institutional_trust", "mean"),
        mean_burnout=("burnout", "mean"),
        mean_narrative_strain=("narrative_strain", "mean"),
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
