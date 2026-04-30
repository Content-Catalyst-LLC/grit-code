"""Synthetic grit and sustained-striving simulation.

This script creates toy longitudinal data for article examples.
It is educational only and not a clinical, diagnostic, hiring, or performance-assessment tool.
"""

from pathlib import Path
import csv
import random

random.seed(42)

n_people = 180
n_waves = 16

rows = []
observation_id = 1

for person_index in range(1, n_people + 1):
    participant = f"P{person_index:03d}"
    goal_id = f"G{person_index:03d}"

    perseverance = random.uniform(0.25, 0.90)
    interest_consistency = random.uniform(0.20, 0.90)
    recovery_capacity = random.uniform(0.20, 0.90)
    self_control_support = random.uniform(0.20, 0.90)
    meaning_alignment = random.uniform(0.20, 0.95)
    support_index = random.uniform(0.15, 0.95)
    friction_load = random.uniform(0.05, 0.80)
    burnout_risk = random.uniform(0.05, 0.65)

    cumulative_progress = 0.0

    for wave in range(1, n_waves + 1):
        setback = random.choice([0.0, 0.0, 0.0, 0.15, 0.30])

        weekly_progress = (
            0.22 * perseverance +
            0.16 * interest_consistency +
            0.16 * recovery_capacity +
            0.14 * self_control_support +
            0.16 * meaning_alignment +
            0.12 * support_index -
            0.18 * friction_load -
            0.14 * burnout_risk -
            0.10 * setback +
            random.gauss(0.0, 0.04)
        )

        weekly_progress = max(0.0, min(1.0, weekly_progress))
        cumulative_progress += weekly_progress

        adaptive_disengagement_signal = max(
            0.0,
            min(1.0, friction_load + burnout_risk - meaning_alignment - 0.25 * support_index)
        )

        rows.append({
            "observation_id": observation_id,
            "participant": participant,
            "goal_id": goal_id,
            "wave": wave,
            "perseverance": round(perseverance, 3),
            "interest_consistency": round(interest_consistency, 3),
            "recovery_capacity": round(recovery_capacity, 3),
            "self_control_support": round(self_control_support, 3),
            "meaning_alignment": round(meaning_alignment, 3),
            "support_index": round(support_index, 3),
            "friction_load": round(friction_load, 3),
            "burnout_risk": round(burnout_risk, 3),
            "adaptive_disengagement_signal": round(adaptive_disengagement_signal, 3),
            "weekly_progress": round(weekly_progress, 3),
            "cumulative_progress": round(cumulative_progress, 3),
        })

        recovery_capacity = max(0.0, min(1.0, recovery_capacity + 0.015 * support_index - 0.018 * setback))
        burnout_risk = max(0.0, min(1.0, burnout_risk + 0.012 * friction_load - 0.010 * recovery_capacity))
        perseverance = max(0.0, min(1.0, perseverance + 0.010 * weekly_progress - 0.008 * burnout_risk))
        interest_consistency = max(0.0, min(1.0, interest_consistency + 0.006 * meaning_alignment - 0.006 * adaptive_disengagement_signal))
        friction_load = max(0.0, min(1.0, friction_load + random.gauss(0.0, 0.025)))

        observation_id += 1

processed = Path(__file__).resolve().parents[1] / "data" / "processed"
processed.mkdir(parents=True, exist_ok=True)

out_path = processed / "synthetic_grit_observations.csv"

with out_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)

print(f"Wrote {len(rows)} grit observations to {out_path}")
