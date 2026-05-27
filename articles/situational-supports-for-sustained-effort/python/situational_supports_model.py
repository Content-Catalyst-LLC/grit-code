"""
Situational supports model for sustained effort.

Synthetic data only. Demonstrates person-environment modeling, grit-by-support
interaction, burnout-risk safety monitoring, goal-progress modeling, and
professional interpretation.
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
n = 1000

age = rng.integers(14, 70, n)
developmental_stage = np.where(
    age < 18,
    "adolescence",
    np.where(age < 30, "emerging_adulthood", np.where(age < 55, "adulthood", "later_adulthood")),
)

perseverance_effort = rng.normal(0, 1, n)
consistency_interests = rng.normal(0, 1, n)
grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

autonomy_support = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
belonging = rng.normal(0, 1, n)
mentoring_access = rng.normal(0, 1, n)
recovery_capacity = rng.normal(0, 1, n)
material_resources = rng.normal(0, 1, n)
fairness = rng.normal(0, 1, n)
psychological_safety = rng.normal(0, 1, n)

demand_intensity = rng.normal(0, 1, n)
chronic_stress = rng.normal(0, 1, n)
blocked_opportunity = rng.normal(0, 1, n)

situational_support = (
    0.16 * autonomy_support
    + 0.16 * feedback_quality
    + 0.16 * belonging
    + 0.12 * mentoring_access
    + 0.14 * recovery_capacity
    + 0.14 * material_resources
    + 0.12 * fairness
    + 0.10 * psychological_safety
)

adaptive_persistence = (
    0.24 * grit
    + 0.26 * situational_support
    + 0.14 * feedback_quality
    + 0.12 * recovery_capacity
    + 0.12 * belonging
    + 0.10 * mentoring_access
    - 0.18 * chronic_stress
    - 0.14 * blocked_opportunity
    + 0.12 * grit * situational_support
    + rng.normal(0, 1, n)
)

burnout_risk = (
    0.28 * demand_intensity
    + 0.20 * chronic_stress
    + 0.16 * grit
    - 0.24 * recovery_capacity
    - 0.18 * autonomy_support
    - 0.16 * psychological_safety
    - 0.12 * fairness
    + rng.normal(0, 1, n)
)

goal_progress = (
    0.22 * adaptive_persistence
    + 0.18 * feedback_quality
    + 0.16 * material_resources
    + 0.14 * mentoring_access
    - 0.12 * blocked_opportunity
    + rng.normal(0, 1, n)
)

wellbeing = (
    0.20 * autonomy_support
    + 0.20 * belonging
    + 0.20 * recovery_capacity
    + 0.14 * fairness
    - 0.24 * burnout_risk
    - 0.16 * chronic_stress
    + rng.normal(0, 1, n)
)

df = pd.DataFrame(
    {
        "age": age,
        "developmental_stage": developmental_stage,
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "autonomy_support": autonomy_support,
        "feedback_quality": feedback_quality,
        "belonging": belonging,
        "mentoring_access": mentoring_access,
        "recovery_capacity": recovery_capacity,
        "material_resources": material_resources,
        "fairness": fairness,
        "psychological_safety": psychological_safety,
        "demand_intensity": demand_intensity,
        "chronic_stress": chronic_stress,
        "blocked_opportunity": blocked_opportunity,
        "situational_support": situational_support,
        "adaptive_persistence": adaptive_persistence,
        "burnout_risk": burnout_risk,
        "goal_progress": goal_progress,
        "wellbeing": wellbeing,
    }
)

df.to_csv(PROCESSED / "situational-supports-modeled-data-python.csv", index=False)

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("age", "count"),
        mean_grit=("grit", "mean"),
        mean_situational_support=("situational_support", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_goal_progress=("goal_progress", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
    )
)

model_grit_only = smf.ols(
    "adaptive_persistence ~ grit + C(developmental_stage)",
    data=df,
).fit()

model_support = smf.ols(
    "adaptive_persistence ~ grit + situational_support + chronic_stress + "
    "blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

model_interaction = smf.ols(
    "adaptive_persistence ~ grit * situational_support + chronic_stress + "
    "blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

model_burnout = smf.ols(
    "burnout_risk ~ grit + demand_intensity + chronic_stress + recovery_capacity + "
    "autonomy_support + psychological_safety + fairness + C(developmental_stage)",
    data=df,
).fit()

model_progress = smf.ols(
    "goal_progress ~ adaptive_persistence + feedback_quality + material_resources + "
    "mentoring_access + blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only_adaptive_persistence",
            "contextual_support_model",
            "grit_by_support_interaction_model",
            "burnout_safety_model",
            "goal_progress_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_support.rsquared,
            model_interaction.rsquared,
            model_burnout.rsquared,
            model_progress.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_support.rsquared_adj,
            model_interaction.rsquared_adj,
            model_burnout.rsquared_adj,
            model_progress.rsquared_adj,
        ],
    }
)

stage_summary.to_csv(OUT / "situational-supports-stage-summary-python.csv", index=False)
comparison.to_csv(OUT / "situational-supports-model-comparison-python.csv", index=False)

pd.DataFrame({"term": model_interaction.params.index, "estimate": model_interaction.params.values}).to_csv(
    OUT / "situational-supports-interaction-coefficients-python.csv", index=False
)
pd.DataFrame({"term": model_burnout.params.index, "estimate": model_burnout.params.values}).to_csv(
    OUT / "situational-supports-burnout-safety-coefficients-python.csv", index=False
)

print("Stage summary")
print(stage_summary.round(3))
print("\nModel comparison")
print(comparison.round(4))
print("\nProfessional caution: synthetic situational-support modeling only.")
