"""
The Development of Grit Across Adolescence and Adulthood

Synthetic-data workflow for modeling grit as a developmental process.
"""

from pathlib import Path
import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "data" / "processed" / "development-of-grit-life-course-modeled-data-python.csv"
TABLE = ROOT / "outputs" / "tables" / "development-of-grit-stage-summary-python.csv"

rng = np.random.default_rng(42)
rows = []

for person_id in range(300):
    baseline_age = rng.choice([12, 18, 30, 55])
    support_base = rng.normal(0, 0.6)
    stress_base = rng.normal(0, 0.6)
    prior_effort = rng.normal(0, 0.5)
    prior_consistency = rng.normal(0, 0.5)

    for wave in range(6):
        age = baseline_age + wave * 2
        stage = (
            "adolescence" if age < 18 else
            "emerging_adulthood" if age < 30 else
            "adulthood" if age < 55 else
            "later_adulthood"
        )

        support = support_base + rng.normal(0, 0.5)
        feedback_quality = rng.normal(0, 1)
        purpose = 0.15 * wave + rng.normal(0, 0.8)
        recovery_capacity = support + rng.normal(0, 0.5)
        chronic_stress = stress_base + rng.normal(0, 0.5)
        opportunity_access = rng.normal(0, 1)

        perseverance_effort = (
            0.45 * prior_effort
            + 0.18 * support
            + 0.18 * feedback_quality
            + 0.20 * purpose
            + 0.15 * recovery_capacity
            + 0.12 * opportunity_access
            - 0.18 * chronic_stress
            + rng.normal(0, 0.7)
        )

        exploration_variability = 0.50 if stage == "adolescence" else 0.25

        consistency_interests = (
            0.50 * prior_consistency
            + 0.22 * purpose
            + 0.12 * opportunity_access
            + 0.10 * support
            - 0.10 * chronic_stress
            + rng.normal(0, exploration_variability)
        )

        grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

        adaptive_persistence = (
            0.24 * grit
            + 0.20 * support
            + 0.18 * feedback_quality
            + 0.20 * purpose
            + 0.16 * recovery_capacity
            + 0.16 * opportunity_access
            - 0.20 * chronic_stress
            + rng.normal(0, 0.8)
        )

        rows.append({
            "person_id": person_id,
            "wave": wave,
            "age": age,
            "stage": stage,
            "support": support,
            "feedback_quality": feedback_quality,
            "purpose": purpose,
            "recovery_capacity": recovery_capacity,
            "chronic_stress": chronic_stress,
            "opportunity_access": opportunity_access,
            "perseverance_effort": perseverance_effort,
            "consistency_interests": consistency_interests,
            "grit": grit,
            "adaptive_persistence": adaptive_persistence,
        })

        prior_effort = perseverance_effort
        prior_consistency = consistency_interests

df = pd.DataFrame(rows)

OUT.parent.mkdir(parents=True, exist_ok=True)
TABLE.parent.mkdir(parents=True, exist_ok=True)

df.to_csv(OUT, index=False)

summary = (
    df.groupby("stage", as_index=False)
    .agg(
        n=("person_id", "count"),
        mean_age=("age", "mean"),
        mean_grit=("grit", "mean"),
        mean_perseverance_effort=("perseverance_effort", "mean"),
        mean_consistency_interests=("consistency_interests", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_support=("support", "mean"),
        mean_purpose=("purpose", "mean"),
        mean_chronic_stress=("chronic_stress", "mean"),
    )
)

summary.to_csv(TABLE, index=False)

print("Saved:", OUT)
print("Saved:", TABLE)
print(summary.round(3))
