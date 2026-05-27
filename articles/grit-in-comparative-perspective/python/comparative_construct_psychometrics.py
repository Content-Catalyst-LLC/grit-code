"""
Psychometrics workflow for "Grit in Comparative Perspective."

Synthetic data only. Demonstrates construct correlation matrices, facet scoring,
comparative interpretation, and cautious professional use. This is not a
validated psychological instrument.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "grit-comparative-perspective-synthetic-survey.csv"
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

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("participant_id", "count"),
        mean_grit=("grit_composite_calculated", "mean"),
        mean_self_control=("self_control", "mean"),
        mean_conscientiousness=("conscientiousness", "mean"),
        mean_resilience_recovery=("resilience_recovery", "mean"),
        mean_practice_quality=("deliberate_practice_quality", "mean"),
        mean_purpose_alignment=("purpose_alignment", "mean"),
        mean_environmental_support=("environmental_support", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
    )
)

incremental_table = pd.DataFrame(
    [
        {
            "comparison": "grit_vs_self_control",
            "interpretation": "Estimate overlap before claiming unique grit effects.",
        },
        {
            "comparison": "grit_vs_conscientiousness",
            "interpretation": "Test whether grit contributes beyond broad conscientiousness.",
        },
        {
            "comparison": "grit_vs_resilience_recovery",
            "interpretation": "Distinguish sustained goal pursuit from recovery after adversity.",
        },
        {
            "comparison": "grit_vs_deliberate_practice",
            "interpretation": "Distinguish effort quantity from feedback-guided effort quality.",
        },
        {
            "comparison": "grit_vs_environmental_support",
            "interpretation": "Check whether context moderates how grit becomes adaptive persistence.",
        },
    ]
)

correlations.to_csv(OUT / "comparative-construct-correlation-matrix.csv")
stage_summary.to_csv(OUT / "comparative-construct-stage-summary.csv", index=False)
incremental_table.to_csv(OUT / "comparative-construct-interpretation-guide.csv", index=False)

print("Construct correlation matrix")
print(correlations.round(3))
print("\nStage summary")
print(stage_summary.round(3))
print("\nProfessional caution: synthetic data only; not a validated instrument.")
