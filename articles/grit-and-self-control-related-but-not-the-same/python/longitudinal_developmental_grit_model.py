"""
Longitudinal/developmental model workflow for professional positive psychology.

Synthetic data only. Demonstrates how grit-related constructs may be modeled
developmentally with support, feedback, purpose, recovery, stress, and outcomes.
"""

from pathlib import Path
import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "outputs" / "tables"
PROCESSED = ROOT / "data" / "processed"
OUT.mkdir(parents=True, exist_ok=True)
PROCESSED.mkdir(parents=True, exist_ok=True)

rng = np.random.default_rng(42)
rows = []

for participant_id in range(1, 201):
    baseline_age = rng.choice([14, 18, 30, 55])
    stable_support = rng.normal(0, 0.6)
    stable_stress = rng.normal(0, 0.6)
    prior_grit = rng.normal(0, 0.5)

    for wave in range(4):
        age = baseline_age + wave
        stage = (
            "adolescence" if age < 18 else
            "emerging_adulthood" if age < 30 else
            "adulthood" if age < 55 else
            "later_adulthood"
        )

        support = stable_support + rng.normal(0, 0.4)
        feedback = rng.normal(0, 1)
        purpose = rng.normal(0, 1) + 0.15 * wave
        recovery = support + rng.normal(0, 0.5)
        stress = stable_stress + rng.normal(0, 0.4)

        grit = (
            0.50 * prior_grit
            + 0.20 * support
            + 0.18 * feedback
            + 0.22 * purpose
            + 0.16 * recovery
            - 0.18 * stress
            + rng.normal(0, 0.7)
        )

        wellbeing = 0.25 * purpose + 0.22 * support + 0.20 * recovery - 0.28 * stress + rng.normal(0, 0.8)
        adaptive_persistence = 0.30 * grit + 0.18 * feedback + 0.20 * recovery + 0.18 * support - 0.16 * stress + rng.normal(0, 0.8)

        rows.append(
            {
                "participant_id": participant_id,
                "wave": wave,
                "age": age,
                "developmental_stage": stage,
                "support": support,
                "feedback_quality": feedback,
                "purpose_alignment": purpose,
                "recovery_capacity": recovery,
                "chronic_stress": stress,
                "grit_latent_demo": grit,
                "wellbeing": wellbeing,
                "adaptive_persistence": adaptive_persistence,
            }
        )

        prior_grit = grit

df = pd.DataFrame(rows)
df.to_csv(PROCESSED / "synthetic-longitudinal-grit-development.csv", index=False)

stage_wave = (
    df.groupby(["developmental_stage", "wave"], as_index=False)
    .agg(
        n=("participant_id", "count"),
        mean_grit=("grit_latent_demo", "mean"),
        mean_wellbeing=("wellbeing", "mean"),
        mean_adaptive_persistence=("adaptive_persistence", "mean"),
        mean_support=("support", "mean"),
        mean_recovery=("recovery_capacity", "mean"),
        mean_stress=("chronic_stress", "mean"),
    )
)

stage_wave.to_csv(OUT / "longitudinal-stage-wave-summary-demo.csv", index=False)

lagged = df.sort_values(["participant_id", "wave"]).copy()
lagged["prior_grit"] = lagged.groupby("participant_id")["grit_latent_demo"].shift(1)
lagged = lagged.dropna()

summary = {
    "correlation_prior_current_grit": lagged["prior_grit"].corr(lagged["grit_latent_demo"]),
    "correlation_grit_adaptive_persistence": lagged["grit_latent_demo"].corr(lagged["adaptive_persistence"]),
    "correlation_recovery_adaptive_persistence": lagged["recovery_capacity"].corr(lagged["adaptive_persistence"]),
    "correlation_stress_grit": lagged["chronic_stress"].corr(lagged["grit_latent_demo"]),
}

pd.DataFrame([summary]).to_csv(OUT / "longitudinal-developmental-correlations-demo.csv", index=False)

print(stage_wave.round(3).head(20))
print(summary)
print("Professional caution: synthetic longitudinal demonstration only.")
