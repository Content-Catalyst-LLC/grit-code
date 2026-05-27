"""
Environmental design model for grit-supportive systems.

Synthetic data only. Demonstrates person-environment modeling, grit-by-design
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
n = 1200

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
competence_support = rng.normal(0, 1, n)
feedback_quality = rng.normal(0, 1, n)
belonging = rng.normal(0, 1, n)
mentoring_access = rng.normal(0, 1, n)
recovery_design = rng.normal(0, 1, n)
material_resources = rng.normal(0, 1, n)
fairness = rng.normal(0, 1, n)
psychological_safety = rng.normal(0, 1, n)
adaptive_quitting_norms = rng.normal(0, 1, n)

demand_intensity = rng.normal(0, 1, n)
chronic_stress = rng.normal(0, 1, n)
blocked_opportunity = rng.normal(0, 1, n)

environment_design = (
    0.13 * autonomy_support
    + 0.13 * competence_support
    + 0.13 * feedback_quality
    + 0.12 * belonging
    + 0.10 * mentoring_access
    + 0.13 * recovery_design
    + 0.10 * material_resources
    + 0.11 * fairness
    + 0.10 * psychological_safety
    + 0.05 * adaptive_quitting_norms
)

adaptive_persistence = (
    0.24 * grit
    + 0.30 * environment_design
    + 0.12 * feedback_quality
    + 0.12 * recovery_design
    + 0.10 * belonging
    + 0.10 * fairness
    - 0.18 * chronic_stress
    - 0.14 * blocked_opportunity
    + 0.12 * grit * environment_design
    + rng.normal(0, 1, n)
)

burnout_risk = (
    0.28 * demand_intensity
    + 0.22 * chronic_stress
    + 0.14 * grit
    - 0.24 * recovery_design
    - 0.18 * autonomy_support
    - 0.16 * psychological_safety
    - 0.12 * fairness
    - 0.10 * adaptive_quitting_norms
    + rng.normal(0, 1, n)
)

goal_progress = (
    0.22 * adaptive_persistence
    + 0.18 * feedback_quality
    + 0.16 * competence_support
    + 0.14 * material_resources
    + 0.12 * mentoring_access
    - 0.12 * blocked_opportunity
    + rng.normal(0, 1, n)
)

wellbeing = (
    0.20 * autonomy_support
    + 0.18 * belonging
    + 0.18 * recovery_design
    + 0.14 * fairness
    + 0.12 * psychological_safety
    - 0.24 * burnout_risk
    - 0.14 * chronic_stress
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
        "competence_support": competence_support,
        "feedback_quality": feedback_quality,
        "belonging": belonging,
        "mentoring_access": mentoring_access,
        "recovery_design": recovery_design,
        "material_resources": material_resources,
        "fairness": fairness,
        "psychological_safety": psychological_safety,
        "adaptive_quitting_norms": adaptive_quitting_norms,
        "demand_intensity": demand_intensity,
        "chronic_stress": chronic_stress,
        "blocked_opportunity": blocked_opportunity,
        "environment_design": environment_design,
        "adaptive_persistence": adaptive_persistence,
        "burnout_risk": burnout_risk,
        "goal_progress": goal_progress,
        "wellbeing": wellbeing,
    }
)

df.to_csv(PROCESSED / "environmental-design-modeled-data-python.csv", index=False)

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("age", "count"),
        mean_grit=("grit", "mean"),
        mean_environment_design=("environment_design", "mean"),
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

model_design = smf.ols(
    "adaptive_persistence ~ grit + environment_design + chronic_stress + "
    "blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

model_interaction = smf.ols(
    "adaptive_persistence ~ grit * environment_design + chronic_stress + "
    "blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

model_burnout = smf.ols(
    "burnout_risk ~ grit + demand_intensity + chronic_stress + recovery_design + "
    "autonomy_support + psychological_safety + fairness + adaptive_quitting_norms + "
    "C(developmental_stage)",
    data=df,
).fit()

model_progress = smf.ols(
    "goal_progress ~ adaptive_persistence + feedback_quality + competence_support + "
    "material_resources + mentoring_access + blocked_opportunity + C(developmental_stage)",
    data=df,
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only_adaptive_persistence",
            "environment_design_model",
            "grit_by_environment_interaction_model",
            "burnout_safety_model",
            "goal_progress_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_design.rsquared,
            model_interaction.rsquared,
            model_burnout.rsquared,
            model_progress.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_design.rsquared_adj,
            model_interaction.rsquared_adj,
            model_burnout.rsquared_adj,
            model_progress.rsquared_adj,
        ],
    }
)

stage_summary.to_csv(OUT / "environmental-design-stage-summary-python.csv", index=False)
comparison.to_csv(OUT / "environmental-design-model-comparison-python.csv", index=False)

pd.DataFrame({"term": model_interaction.params.index, "estimate": model_interaction.params.values}).to_csv(
    OUT / "environmental-design-interaction-coefficients-python.csv", index=False
)
pd.DataFrame({"term": model_burnout.params.index, "estimate": model_burnout.params.values}).to_csv(
    OUT / "environmental-design-burnout-safety-coefficients-python.csv", index=False
)

print("Stage summary")
print(stage_summary.round(3))
print("\nModel comparison")
print(comparison.round(4))
print("\nProfessional caution: synthetic environmental-design modeling only.")
