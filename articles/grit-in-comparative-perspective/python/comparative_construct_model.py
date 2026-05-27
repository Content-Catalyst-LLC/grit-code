"""
Comparative construct model for "Grit in Comparative Perspective."

Synthetic data only. Demonstrates grit-only vs comparative models, construct
overlap, moderation by environmental support, goal-progress modeling, and
burnout-risk safety monitoring.
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

self_control = rng.normal(0, 1, n)
conscientiousness = 0.40 * self_control + rng.normal(0, 1, n)
resilience_recovery = rng.normal(0, 1, n)
deliberate_practice_quality = rng.normal(0, 1, n)
motivation_quality = rng.normal(0, 1, n)
purpose_alignment = rng.normal(0, 1, n)
growth_mindset = rng.normal(0, 1, n)
narrative_identity_flexibility = rng.normal(0, 1, n)
environmental_support = rng.normal(0, 1, n)
autonomy_support = rng.normal(0, 1, n)
chronic_stress = rng.normal(0, 1, n)
demand_intensity = rng.normal(0, 1, n)

perseverance_effort = (
    0.30 * conscientiousness
    + 0.18 * self_control
    + 0.20 * purpose_alignment
    + 0.14 * environmental_support
    + rng.normal(0, 1, n)
)

consistency_interests = (
    0.22 * conscientiousness
    + 0.12 * self_control
    + 0.28 * purpose_alignment
    + 0.10 * environmental_support
    + rng.normal(0, 1, n)
)

grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

adaptive_persistence = (
    0.22 * grit
    + 0.14 * self_control
    + 0.14 * conscientiousness
    + 0.14 * resilience_recovery
    + 0.16 * deliberate_practice_quality
    + 0.14 * motivation_quality
    + 0.16 * purpose_alignment
    + 0.10 * growth_mindset
    + 0.10 * narrative_identity_flexibility
    + 0.18 * environmental_support
    - 0.16 * chronic_stress
    + 0.10 * grit * environmental_support
    + rng.normal(0, 1, n)
)

goal_progress = (
    0.18 * adaptive_persistence
    + 0.20 * deliberate_practice_quality
    + 0.16 * environmental_support
    + 0.14 * conscientiousness
    + 0.12 * purpose_alignment
    - 0.12 * chronic_stress
    + rng.normal(0, 1, n)
)

burnout_risk = (
    0.28 * demand_intensity
    + 0.18 * chronic_stress
    + 0.14 * grit
    - 0.22 * resilience_recovery
    - 0.18 * autonomy_support
    - 0.12 * environmental_support
    + rng.normal(0, 1, n)
)

wellbeing = (
    0.22 * resilience_recovery
    + 0.18 * purpose_alignment
    + 0.16 * environmental_support
    + 0.14 * autonomy_support
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
        "resilience_recovery": resilience_recovery,
        "deliberate_practice_quality": deliberate_practice_quality,
        "motivation_quality": motivation_quality,
        "purpose_alignment": purpose_alignment,
        "growth_mindset": growth_mindset,
        "narrative_identity_flexibility": narrative_identity_flexibility,
        "environmental_support": environmental_support,
        "autonomy_support": autonomy_support,
        "chronic_stress": chronic_stress,
        "demand_intensity": demand_intensity,
        "perseverance_effort": perseverance_effort,
        "consistency_interests": consistency_interests,
        "grit": grit,
        "adaptive_persistence": adaptive_persistence,
        "goal_progress": goal_progress,
        "burnout_risk": burnout_risk,
        "wellbeing": wellbeing,
    }
)

df.to_csv(PROCESSED / "grit-comparative-perspective-modeled-data-python.csv", index=False)

constructs = [
    "grit",
    "perseverance_effort",
    "consistency_interests",
    "self_control",
    "conscientiousness",
    "resilience_recovery",
    "deliberate_practice_quality",
    "motivation_quality",
    "purpose_alignment",
    "growth_mindset",
    "narrative_identity_flexibility",
    "environmental_support",
    "adaptive_persistence",
    "goal_progress",
    "burnout_risk",
    "wellbeing",
]

correlations = df[constructs].corr()

model_grit_only = smf.ols(
    "adaptive_persistence ~ grit + C(developmental_stage)",
    data=df,
).fit()

model_comparative = smf.ols(
    "adaptive_persistence ~ grit + self_control + conscientiousness + "
    "resilience_recovery + deliberate_practice_quality + motivation_quality + "
    "purpose_alignment + growth_mindset + narrative_identity_flexibility + "
    "environmental_support + chronic_stress + C(developmental_stage)",
    data=df,
).fit()

model_interaction = smf.ols(
    "adaptive_persistence ~ grit * environmental_support + self_control + "
    "conscientiousness + resilience_recovery + deliberate_practice_quality + "
    "purpose_alignment + chronic_stress + C(developmental_stage)",
    data=df,
).fit()

model_goal_progress = smf.ols(
    "goal_progress ~ adaptive_persistence + grit + deliberate_practice_quality + "
    "environmental_support + conscientiousness + purpose_alignment + chronic_stress + "
    "C(developmental_stage)",
    data=df,
).fit()

model_burnout = smf.ols(
    "burnout_risk ~ grit + demand_intensity + chronic_stress + resilience_recovery + "
    "autonomy_support + environmental_support + C(developmental_stage)",
    data=df,
).fit()

comparison = pd.DataFrame(
    {
        "model": [
            "grit_only_adaptive_persistence",
            "comparative_construct_model",
            "grit_by_environment_support_model",
            "goal_progress_model",
            "burnout_safety_model",
        ],
        "r_squared": [
            model_grit_only.rsquared,
            model_comparative.rsquared,
            model_interaction.rsquared,
            model_goal_progress.rsquared,
            model_burnout.rsquared,
        ],
        "adjusted_r_squared": [
            model_grit_only.rsquared_adj,
            model_comparative.rsquared_adj,
            model_interaction.rsquared_adj,
            model_goal_progress.rsquared_adj,
            model_burnout.rsquared_adj,
        ],
    }
)

correlations.to_csv(OUT / "comparative-construct-correlation-matrix-python.csv")
comparison.to_csv(OUT / "comparative-construct-model-comparison-python.csv", index=False)

pd.DataFrame({"term": model_comparative.params.index, "estimate": model_comparative.params.values}).to_csv(
    OUT / "comparative-construct-model-coefficients-python.csv", index=False
)

pd.DataFrame({"term": model_burnout.params.index, "estimate": model_burnout.params.values}).to_csv(
    OUT / "comparative-construct-burnout-safety-coefficients-python.csv", index=False
)

print("Model comparison")
print(comparison.round(4))
print("\nProfessional caution: synthetic comparative construct modeling only.")
