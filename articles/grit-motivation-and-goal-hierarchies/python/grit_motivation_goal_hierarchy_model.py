"""
Grit, Motivation, and Goal Hierarchies

Synthetic-data workflow for modeling grit, motivation, goal-hierarchy
coherence, support, feedback, burnout, and long-term progress.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-motivation-goal-hierarchy-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-motivation-goal-hierarchy-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-motivation-goal-hierarchy-profile-summary-python.csv"
CORR_OUT = ROOT / "outputs" / "tables" / "grit-motivation-goal-hierarchy-correlations-python.csv"

rng = np.random.default_rng(42)
n = 900

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

intrinsic_interest = rng.normal(0, 1, n)
identified_value = rng.normal(0, 1, n)
purpose_orientation = rng.normal(0, 1, n)
extrinsic_pressure = rng.normal(0, 1, n)

motivation = (
    0.30 * intrinsic_interest
    + 0.30 * identified_value
    + 0.30 * purpose_orientation
    + 0.10 * extrinsic_pressure
)

superordinate_clarity = rng.normal(0, 1, n)
midlevel_planning = rng.normal(0, 1, n)
daily_action_alignment = rng.normal(0, 1, n)

goal_hierarchy_coherence = (
    0.35 * superordinate_clarity
    + 0.30 * midlevel_planning
    + 0.35 * daily_action_alignment
)

social_support = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)

burnout = (
    0.20 * grit
    + 0.15 * extrinsic_pressure
    - 0.25 * social_support
    - 0.20 * goal_hierarchy_coherence
    + rng.normal(0, 1, n)
)

long_term_progress = (
    0.20 * grit
    + 0.24 * motivation
    + 0.30 * goal_hierarchy_coherence
    + 0.18 * social_support
    + 0.16 * feedback_quality
    - 0.20 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "intrinsic_interest": intrinsic_interest,
        "identified_value": identified_value,
        "purpose_orientation": purpose_orientation,
        "extrinsic_pressure": extrinsic_pressure,
        "motivation": motivation,
        "superordinate_clarity": superordinate_clarity,
        "midlevel_planning": midlevel_planning,
        "daily_action_alignment": daily_action_alignment,
        "goal_hierarchy_coherence": goal_hierarchy_coherence,
        "social_support": social_support,
        "feedback_quality": feedback_quality,
        "burnout": burnout,
        "long_term_progress": long_term_progress,
    }
)

grit_median = df["grit"].median()
hierarchy_median = df["goal_hierarchy_coherence"].median()

conditions = [
    (df["grit"] >= grit_median) & (df["goal_hierarchy_coherence"] >= hierarchy_median),
    (df["grit"] >= grit_median) & (df["goal_hierarchy_coherence"] < hierarchy_median),
    (df["grit"] < grit_median) & (df["goal_hierarchy_coherence"] >= hierarchy_median),
    (df["grit"] < grit_median) & (df["goal_hierarchy_coherence"] < hierarchy_median),
]
choices = [
    "high_grit_high_hierarchy_coherence",
    "high_grit_low_hierarchy_coherence",
    "low_grit_high_hierarchy_coherence",
    "low_grit_low_hierarchy_coherence",
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
        "motivation",
        "goal_hierarchy_coherence",
        "social_support",
        "feedback_quality",
        "burnout",
        "long_term_progress",
    ]
].corr()

correlations.to_csv(CORR_OUT)

model_grit_only = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(df[["grit"]]),
).fit()

model_hierarchy = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(df[["grit", "motivation", "goal_hierarchy_coherence"]]),
).fit()

model_contextual = sm.OLS(
    df["long_term_progress"],
    sm.add_constant(
        df[
            [
                "grit",
                "motivation",
                "goal_hierarchy_coherence",
                "social_support",
                "feedback_quality",
                "burnout",
            ]
        ]
    ),
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only",
            "grit_motivation_hierarchy",
            "contextual_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_hierarchy.rsquared,
            model_contextual.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_hierarchy.rsquared_adj,
            model_contextual.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_grit=("grit", "mean"),
        mean_motivation=("motivation", "mean"),
        mean_goal_hierarchy_coherence=("goal_hierarchy_coherence", "mean"),
        mean_social_support=("social_support", "mean"),
        mean_burnout=("burnout", "mean"),
        mean_long_term_progress=("long_term_progress", "mean"),
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
