"""
Adaptive-persistence model for "Why Grit Still Matters."

Synthetic data only. Demonstrates grit-only vs context-rich models, grit-by-
environment moderation, goal-progress modeling, burnout-risk safety monitoring,
and wellbeing modeling.
"""

from pathlib import Path
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "outputs" / "tables"
PROCESSED = ROOT / "data" / "processed"
OUT.mkdir(parents=True, exist_ok=True)
PROCESSED.mkdir(parents=True, exist_ok=True)

rng = np.random.default_rng(42)
n = 1400

age = rng.integers(14, 70, n)
developmental_stage = np.where(
    age < 18,
    "adolescence",
    np.where(age < 30, "emerging_adulthood", np.where(age < 55, "adulthood", "later_adulthood")),
)

self_control = rng.normal(0, 1, n)
conscientiousness = 0.40 * self_control + rng.normal(0, 1, n)
purpose_alignment = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
recovery_capacity = rng.normal(0, 1, n)
environmental_support = rng.normal(0, 1, n)
autonomy_support = rng.normal(0, 1, n)
social_support = rng.normal(0, 1, n)
practice_quality = rng.normal(0, 1, n)
demand_intensity = rng.normal(0, 1, n)
chronic_stress = rng.normal(0, 1, n)
blocked_opportunity = rng.normal(0, 1, n)

perseverance_effort = (
    0.28 * conscientiousness
    + 0.18 * self_control
    + 0.22 * purpose_alignment
    + 0.12 * environmental_support
    + rng.normal(0, 1, n)
)

consistency_interests = (
    0.22 * conscientiousness
    + 0.12 * self_control
    + 0.30 * purpose_alignment
    + 0.10 * environmental_support
    + rng.normal(0, 1, n)
)

grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

adaptive_persistence = (
    0.22 * grit
    + 0.14 * self_control
    + 0.14 * practice_quality
    + 0.16 * purpose_alignment
    + 0.16 * feedback_quality
    + 0.16 * recovery_capacity
    + 0.18 * environmental_support
    + 0.12 * social_support
    - 0.14 * chronic_stress
    - 0.12 * blocked_opportunity
    + 0.10 * grit * environmental_support
    + rng.normal(0, 1, n)
)

goal_progress = (
    0.20 * adaptive_persistence
    + 0.18 * practice_quality
    + 0.16 * feedback_quality
    + 0.14 * purpose_alignment
    + 0.12 * environmental_support
    - 0.12 * blocked_opportunity
    + rng.normal(0, 1, n)
)

burnout_risk = (
    0.26 * demand_intensity
    + 0.22 * chronic_stress
    + 0.12 * grit
    - 0.22 * recovery_capacity
    - 0.16 * autonomy_support
    - 0.14 * social_support
    - 0.12 * environmental_support
    + rng.normal(0, 1, n)
)

wellbeing = (
    0.18 * purpose_alignment
    + 0.18 * recovery_capacity
    + 0.16 * social_support
    + 0.14 * autonomy_support
    + 0.12 * environmental_support
    - 0.24 * burnout_risk
    - 0.12 * chronic_stress
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "age": age,
        "developmental_stage": developmental_stage,
        "self_control": self_control,
        "conscientiousness": conscientiousness,
        "purpose_alignment": purpose_alignment,
        "feedback_quality": feedback_quality,
        "recovery_capacity": recovery_capacity,
        "environmental_support": environmental_support,
        "autonomy_support": autonomy_support,
        "social_support": social_support,
        "practice_quality": practice_quality,
        "demand_intensity": demand_intensity,
        "chronic_stress": chronic_stress,
        "blocked_opportunity": blocked_opportunity,
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "adaptive_persistence": adaptive_persistence,
        "goal_progress": goal_progress,
        "burnout_risk": burnout_risk,
        "wellbeing": wellbeing,
    }
)

df.to_csv(PROCESSED / "why-grit-still-matters-modeled-data-python.csv", index=False)

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("age", "count"),
        mean_grit=("grit", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_goal_progress=("goal_progress", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
        mean_environmental_support=("environmental_support", "mean"),
    )
)

model_grit_only = smf.ols(
    "adaptive_persistence ~ grit + C(developmental_stage)",
    data=df,
).fit()

model_comparative = smf.ols(
    "adaptive_persistence ~ grit + self_control + conscientiousness + "
    "purpose_alignment + feedback_quality + practice_quality + recovery_capacity + "
    "environmental_support + social_support + chronic_stress + blocked_opportunity + "
    "C(developmental_stage)",
    data=df,
).fit()

model_interaction = smf.ols(
    "adaptive_persistence ~ grit * environmental_support + self_control + "
    "purpose_alignment + feedback_quality + recovery_capacity + chronic_stress + "
    "blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

model_progress = smf.ols(
    "goal_progress ~ adaptive_persistence + grit + practice_quality + feedback_quality + "
    "purpose_alignment + environmental_support + blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

model_burnout = smf.ols(
    "burnout_risk ~ grit + demand_intensity + chronic_stress + recovery_capacity + "
    "autonomy_support + social_support + environmental_support + C(developmental_stage)",
    data=df,
).fit()

model_wellbeing = smf.ols(
    "wellbeing ~ grit + adaptive_persistence + purpose_alignment + recovery_capacity + "
    "social_support + autonomy_support + burnout_risk + chronic_stress + C(developmental_stage)",
    data=df,
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only_adaptive_persistence",
            "comparative_adaptive_persistence_model",
            "grit_by_environment_interaction_model",
            "goal_progress_model",
            "burnout_safety_model",
            "wellbeing_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_comparative.rsquared,
            model_interaction.rsquared,
            model_progress.rsquared,
            model_burnout.rsquared,
            model_wellbeing.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_comparative.rsquared_adj,
            model_interaction.rsquared_adj,
            model_progress.rsquared_adj,
            model_burnout.rsquared_adj,
            model_wellbeing.rsquared_adj,
        ],
    }
)

stage_summary.to_csv(OUT / "why-grit-still-matters-stage-summary-python.csv", index=False)
comparison.to_csv(OUT / "why-grit-still-matters-model-comparison-python.csv", index=False)

pd.DataFrame({"term": model_comparative.params.index, "estimate": model_comparative.params.values}).to_csv(
    OUT / "why-grit-still-matters-comparative-model-coefficients-python.csv", index=False
)

pd.DataFrame({"term": model_burnout.params.index, "estimate": model_burnout.params.values}).to_csv(
    OUT / "why-grit-still-matters-burnout-safety-coefficients-python.csv", index=False
)

print("Developmental-stage summary")
print(stage_summary.round(3))
print("\nModel comparison")
print(comparison.round(4))
print("\nProfessional caution: synthetic adaptive-persistence modeling only.")
