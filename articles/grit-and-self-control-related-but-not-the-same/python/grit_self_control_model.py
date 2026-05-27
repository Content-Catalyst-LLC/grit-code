"""
Grit and Self-Control: Related but Not the Same

Synthetic-data workflow for modeling self-control and grit as related but
separable predictors of daily task completion and long-term goal progress.

This script is for article support and research-method demonstration only.
It should not be used to assess, rank, hire, discipline, or evaluate real people.
"""

from pathlib import Path

import numpy as np
import pandas as pd
import statsmodels.api as sm


ROOT = Path(__file__).resolve().parents[1]
DATA_OUT = ROOT / "data" / "processed" / "grit-self-control-modeled-data-python.csv"
TABLE_OUT = ROOT / "outputs" / "tables" / "grit-self-control-model-comparison-python.csv"
PROFILE_OUT = ROOT / "outputs" / "tables" / "grit-self-control-profile-summary-python.csv"

rng = np.random.default_rng(42)
n = 900

attention_regulation = rng.normal(0, 1, n)
emotion_regulation = rng.normal(0, 1, n)
impulse_control = rng.normal(0, 1, n)

self_control = (
    0.40 * attention_regulation
    + 0.30 * emotion_regulation
    + 0.30 * impulse_control
)

perseverance_effort = 0.35 * self_control + rng.normal(0, 0.90, n)
consistency_interests = rng.normal(0, 1, n)

grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

conscientiousness = 0.45 * self_control + 0.45 * perseverance_effort + rng.normal(0, 0.85, n)
social_support = rng.normal(0, 1, n)
prior_achievement = rng.normal(0, 1, n)
burnout = rng.normal(0, 1, n)

daily_task_completion = (
    0.42 * self_control
    + 0.15 * grit
    + 0.20 * conscientiousness
    + 0.15 * social_support
    - 0.25 * burnout
    + rng.normal(0, 1, n)
)

long_term_goal_progress = (
    0.18 * self_control
    + 0.34 * grit
    + 0.24 * prior_achievement
    + 0.18 * social_support
    - 0.22 * burnout
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "attention_regulation": attention_regulation,
        "emotion_regulation": emotion_regulation,
        "impulse_control": impulse_control,
        "self_control": self_control,
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "conscientiousness": conscientiousness,
        "social_support": social_support,
        "prior_achievement": prior_achievement,
        "burnout": burnout,
        "daily_task_completion": daily_task_completion,
        "long_term_goal_progress": long_term_goal_progress,
    }
)

sc_median = df["self_control"].median()
grit_median = df["grit"].median()

conditions = [
    (df["self_control"] >= sc_median) & (df["grit"] >= grit_median),
    (df["self_control"] >= sc_median) & (df["grit"] < grit_median),
    (df["self_control"] < sc_median) & (df["grit"] >= grit_median),
    (df["self_control"] < sc_median) & (df["grit"] < grit_median),
]
choices = [
    "high_self_control_high_grit",
    "high_self_control_low_grit",
    "low_self_control_high_grit",
    "low_self_control_low_grit",
]
df["profile"] = np.select(conditions, choices, default="unclassified")

DATA_OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE_OUT.parent.mkdir(parents=True, exist_ok=True)
PROFILE_OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(DATA_OUT, index=False)

daily_self_control_model = sm.OLS(
    df["daily_task_completion"],
    sm.add_constant(df[["self_control"]]),
).fit()

daily_grit_model = sm.OLS(
    df["daily_task_completion"],
    sm.add_constant(df[["grit"]]),
).fit()

daily_combined_model = sm.OLS(
    df["daily_task_completion"],
    sm.add_constant(df[["self_control", "grit"]]),
).fit()

daily_contextual_model = sm.OLS(
    df["daily_task_completion"],
    sm.add_constant(
        df[
            [
                "self_control",
                "grit",
                "conscientiousness",
                "social_support",
                "burnout",
            ]
        ]
    ),
).fit()

long_term_contextual_model = sm.OLS(
    df["long_term_goal_progress"],
    sm.add_constant(
        df[
            [
                "self_control",
                "grit",
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
            "daily_self_control_only",
            "daily_grit_only",
            "daily_self_control_plus_grit",
            "daily_contextual",
            "long_term_contextual",
        ],
        "outcome": [
            "daily_task_completion",
            "daily_task_completion",
            "daily_task_completion",
            "daily_task_completion",
            "long_term_goal_progress",
        ],
        "r_squared": [
            daily_self_control_model.rsquared,
            daily_grit_model.rsquared,
            daily_combined_model.rsquared,
            daily_contextual_model.rsquared,
            long_term_contextual_model.rsquared,
        ],
        "adjusted_r_squared": [
            daily_self_control_model.rsquared_adj,
            daily_grit_model.rsquared_adj,
            daily_combined_model.rsquared_adj,
            daily_contextual_model.rsquared_adj,
            long_term_contextual_model.rsquared_adj,
        ],
    }
)

profile_summary = (
    df.groupby("profile", as_index=False)
    .agg(
        n=("profile", "size"),
        mean_self_control=("self_control", "mean"),
        mean_grit=("grit", "mean"),
        mean_daily_task_completion=("daily_task_completion", "mean"),
        mean_long_term_goal_progress=("long_term_goal_progress", "mean"),
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
