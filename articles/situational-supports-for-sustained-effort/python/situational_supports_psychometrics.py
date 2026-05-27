"""
Psychometrics workflow for "Situational Supports for Sustained Effort."

Synthetic data only. Demonstrates support-facet scoring, reliability-style
thinking, contextual validity correlations, and cautious interpretation.
This is not a validated psychological instrument.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "situational-supports-synthetic-survey.csv"
OUT = ROOT / "outputs" / "tables"
OUT.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA)

support_facets = [
    "autonomy_support",
    "feedback_quality",
    "belonging",
    "mentoring_access",
    "recovery_capacity",
    "material_resources",
    "fairness",
    "psychological_safety",
]

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

df["situational_support_composite"] = df[support_facets].mean(axis=1)

reliability = pd.DataFrame(
    [
        {
            "scale": "situational_support_composite",
            "n_items": len(support_facets),
            "cronbach_alpha_demo": cronbach_alpha(df[support_facets]),
        }
    ]
)

correlation_variables = [
    "grit_composite",
    "situational_support_composite",
    "autonomy_support",
    "feedback_quality",
    "belonging",
    "recovery_capacity",
    "material_resources",
    "fairness",
    "psychological_safety",
    "chronic_stress",
    "blocked_opportunity",
    "adaptive_persistence",
    "burnout_risk",
    "goal_progress",
    "wellbeing",
]

correlations = df[correlation_variables].corr()

stage_summary = (
    df.groupby("developmental_stage", as_index=False)
    .agg(
        n=("participant_id", "count"),
        mean_grit=("grit_composite", "mean"),
        mean_situational_support=("situational_support_composite", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_goal_progress=("goal_progress", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
    )
)

reliability.to_csv(OUT / "situational-supports-reliability-demo.csv", index=False)
item_total_correlations(df[support_facets]).to_csv(
    OUT / "situational-supports-item-total-correlations-demo.csv", index=False
)
correlations.to_csv(OUT / "situational-supports-contextual-validity-correlations.csv")
stage_summary.to_csv(OUT / "situational-supports-stage-summary.csv", index=False)

print("Reliability demonstration")
print(reliability.round(3))
print("\nStage summary")
print(stage_summary.round(3))
print("\nProfessional caution: synthetic data only; not a validated instrument.")
