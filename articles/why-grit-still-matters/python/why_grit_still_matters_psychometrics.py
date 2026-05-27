"""
Psychometrics workflow for "Why Grit Still Matters."

Synthetic data only. Demonstrates grit facet scoring, construct correlation
matrices, contextual interpretation, and cautious professional use. This is
not a validated psychological instrument.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "why-grit-still-matters-synthetic-survey.csv"
OUT = ROOT / "outputs" / "tables"
OUT.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA)

df["grit_composite_calculated"] = df[["perseverance_effort", "consistency_interests"]].mean(axis=1)

constructs = [
    "grit_composite_calculated",
    "perseverance_effort",
    "consistency_interests",
    "self_control",
    "conscientiousness",
    "purpose_alignment",
    "feedback_quality",
    "practice_quality",
    "recovery_capacity",
    "environmental_support",
    "social_support",
    "autonomy_support",
    "chronic_stress",
    "blocked_opportunity",
    "adaptive_persistence",
    "goal_progress",
    "burnout_risk",
    "wellbeing",
]

correlations = df[constructs].corr()

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("participant_id", "count"),
        mean_grit=("grit_composite_calculated", "mean"),
        mean_purpose_alignment=("purpose_alignment", "mean"),
        mean_feedback_quality=("feedback_quality", "mean"),
        mean_recovery_capacity=("recovery_capacity", "mean"),
        mean_environmental_support=("environmental_support", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_goal_progress=("goal_progress", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
    )
)

interpretation_guide = pd.DataFrame(
    [
        {
            "topic": "grit still matters",
            "professional_interpretation": "Grit can contribute to adaptive persistence, but it should be interpreted with purpose, feedback, support, recovery, and context.",
        },
        {
            "topic": "measurement humility",
            "professional_interpretation": "Do not use grit scores as high-stakes individual labels.",
        },
        {
            "topic": "burnout safety",
            "professional_interpretation": "High persistence should be interpreted with burnout risk and recovery capacity.",
        },
        {
            "topic": "adaptive quitting",
            "professional_interpretation": "Some disengagement is wise when goals become harmful, futile, unethical, or misaligned.",
        },
        {
            "topic": "equity",
            "professional_interpretation": "Persistence should be interpreted with opportunity, support, and institutional conditions.",
        },
    ]
)

correlations.to_csv(OUT / "why-grit-still-matters-correlation-matrix.csv")
stage_summary.to_csv(OUT / "why-grit-still-matters-stage-summary.csv", index=False)
interpretation_guide.to_csv(OUT / "why-grit-still-matters-interpretation-guide.csv", index=False)

print("Construct correlation matrix")
print(correlations.round(3))
print("\nDevelopmental-stage summary")
print(stage_summary.round(3))
print("\nProfessional caution: synthetic data only; not a validated instrument.")
