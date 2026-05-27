"""
Psychometrics workflow for a professional positive psychology research scaffold.

Synthetic data only. This workflow demonstrates reliability, item-total
correlations, facet scores, convergent/discriminant checks, and cautious
interpretation. It is not a validated psychological instrument.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "synthetic-positive-psychology-survey.csv"
OUT = ROOT / "outputs" / "tables"
OUT.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA)

perseverance_items = [
    "perseverance_item_1",
    "perseverance_item_2",
    "perseverance_item_3",
    "perseverance_item_4",
]

consistency_items = [
    "consistency_item_1",
    "consistency_item_2",
    "consistency_item_3",
    "consistency_item_4",
]

all_items = perseverance_items + consistency_items


def cronbach_alpha(frame: pd.DataFrame) -> float:
    item_scores = frame.astype(float)
    item_variances = item_scores.var(axis=0, ddof=1)
    total_score = item_scores.sum(axis=1)
    n_items = item_scores.shape[1]
    total_variance = total_score.var(ddof=1)
    if n_items <= 1 or total_variance == 0:
        return float("nan")
    return (n_items / (n_items - 1)) * (1 - item_variances.sum() / total_variance)


def item_total_correlations(frame: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for col in frame.columns:
        item = frame[col].astype(float)
        rest = frame.drop(columns=[col]).sum(axis=1).astype(float)
        rows.append(
            {
                "item": col,
                "corrected_item_total_correlation": item.corr(rest),
                "item_mean": item.mean(),
                "item_sd": item.std(ddof=1),
            }
        )
    return pd.DataFrame(rows)


df["perseverance_score"] = df[perseverance_items].mean(axis=1)
df["consistency_score"] = df[consistency_items].mean(axis=1)
df["grit_composite"] = df[all_items].mean(axis=1)

reliability = pd.DataFrame(
    [
        {
            "scale": "perseverance_of_effort",
            "n_items": len(perseverance_items),
            "cronbach_alpha_demo": cronbach_alpha(df[perseverance_items]),
        },
        {
            "scale": "consistency_of_interests",
            "n_items": len(consistency_items),
            "cronbach_alpha_demo": cronbach_alpha(df[consistency_items]),
        },
        {
            "scale": "grit_composite",
            "n_items": len(all_items),
            "cronbach_alpha_demo": cronbach_alpha(df[all_items]),
        },
    ]
)

validity_variables = [
    "perseverance_score",
    "consistency_score",
    "grit_composite",
    "purpose_alignment",
    "feedback_responsiveness",
    "recovery_capacity",
    "social_support",
    "burnout_risk",
    "adaptive_persistence",
    "wellbeing",
    "goal_progress",
]

correlations = df[validity_variables].corr()

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("participant_id", "count"),
        mean_grit=("grit_composite", "mean"),
        mean_perseverance=("perseverance_score", "mean"),
        mean_consistency=("consistency_score", "mean"),
        mean_purpose=("purpose_alignment", "mean"),
        mean_recovery=("recovery_capacity", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
    )
)

reliability.to_csv(OUT / "psychometrics-reliability-demo.csv", index=False)
item_total_correlations(df[all_items]).to_csv(
    OUT / "psychometrics-item-total-correlations-demo.csv", index=False
)
correlations.to_csv(OUT / "psychometrics-validity-correlation-demo.csv")
stage_summary.to_csv(OUT / "psychometrics-stage-summary-demo.csv", index=False)

print("Reliability demonstration")
print(reliability.round(3))
print("\nStage summary")
print(stage_summary.round(3))
print("\nProfessional caution: synthetic data only; not a validated instrument.")
