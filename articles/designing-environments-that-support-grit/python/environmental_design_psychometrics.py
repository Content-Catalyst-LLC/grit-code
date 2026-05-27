"""
Psychometrics workflow for "Designing Environments That Support Grit."

Synthetic data only. Demonstrates environmental-design composite scoring,
reliability-style thinking, contextual validity correlations, and cautious
professional interpretation. This is not a validated psychological instrument.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "raw" / "designing-environments-that-support-grit-synthetic-survey.csv"
OUT = ROOT / "outputs" / "tables"
OUT.mkdir(parents=True, exist_ok=True)

df = pd.read_csv(DATA)

design_facets = [
    "autonomy_support",
    "competence_support",
    "feedback_quality",
    "belonging",
    "mentoring_access",
    "recovery_design",
    "material_resources",
    "fairness",
    "psychological_safety",
    "adaptive_quitting_norms",
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

df["environment_design_composite_calculated"] = df[design_facets].mean(axis=1)

reliability = pd.DataFrame(
    [
        {
            "scale": "environment_design_composite",
            "n_items": len(design_facets),
            "cronbach_alpha_demo": cronbach_alpha(df[design_facets]),
        }
    ]
)

correlation_variables = [
    "grit_composite",
    "environment_design_composite_calculated",
    "autonomy_support",
    "competence_support",
    "feedback_quality",
    "belonging",
    "recovery_design",
    "fairness",
    "psychological_safety",
    "adaptive_quitting_norms",
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
        mean_environment_design=("environment_design_composite_calculated", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_burnout_risk=("burnout_risk", "mean"),
        mean_goal_progress=("goal_progress", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
    )
)

reliability.to_csv(OUT / "environmental-design-reliability-demo.csv", index=False)
item_total_correlations(df[design_facets]).to_csv(
    OUT / "environmental-design-item-total-correlations-demo.csv", index=False
)
correlations.to_csv(OUT / "environmental-design-contextual-validity-correlations.csv")
stage_summary.to_csv(OUT / "environmental-design-stage-summary.csv", index=False)

print("Reliability demonstration")
print(reliability.round(3))
print("\nStage summary")
print(stage_summary.round(3))
print("\nProfessional caution: synthetic data only; not a validated instrument.")
