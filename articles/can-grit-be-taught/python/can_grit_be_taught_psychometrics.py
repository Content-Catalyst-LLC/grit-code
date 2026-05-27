"""
Psychometrics workflow for "Can Grit Be Taught?"

Synthetic data only. Demonstrates reliability-style thinking, pre/post
facet scoring, and validity-oriented correlations. This is not a validated
instrument.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "can-grit-be-taught-synthetic-intervention-survey.csv"
OUT = ROOT / "outputs" / "tables"
OUT.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA)

baseline_facets = ["baseline_perseverance", "baseline_consistency"]
post_facets = ["post_perseverance", "post_consistency"]

df["baseline_grit_composite"] = df[baseline_facets].mean(axis=1)
df["post_grit_composite"] = df[post_facets].mean(axis=1)
df["grit_change"] = df["post_grit_composite"] - df["baseline_grit_composite"]
df["adaptive_persistence_change"] = (
    df["post_adaptive_persistence"] - df["baseline_adaptive_persistence"]
)
df["burnout_risk_change"] = df["post_burnout_risk"] - df["baseline_burnout_risk"]

summary_by_condition = (
    df.groupby("condition", as_index=False)
    .agg(
        n=("participant_id", "count"),
        mean_baseline_grit=("baseline_grit_composite", "mean"),
        mean_post_grit=("post_grit_composite", "mean"),
        mean_grit_change=("grit_change", "mean"),
        mean_adaptive_persistence_change=("adaptive_persistence_change", "mean"),
        mean_burnout_risk_change=("burnout_risk_change", "mean"),
        mean_post_wellbeing=("post_wellbeing", "mean"),
        mean_intervention_acceptability=("intervention_acceptability", "mean"),
    )
)

correlation_variables = [
    "baseline_grit_composite",
    "post_grit_composite",
    "grit_change",
    "post_purpose_alignment",
    "post_feedback_responsiveness",
    "post_recovery_capacity",
    "post_burnout_risk",
    "post_wellbeing",
    "goal_progress",
    "intervention_acceptability",
]

correlations = df[correlation_variables].corr()

summary_by_condition.to_csv(OUT / "can-grit-be-taught-summary-by-condition.csv", index=False)
correlations.to_csv(OUT / "can-grit-be-taught-validity-correlations.csv")

print("Summary by condition")
print(summary_by_condition.round(3))
print("\nValidity-oriented correlations")
print(correlations.round(3))
print("\nProfessional caution: synthetic data only; not a validated psychological instrument.")
