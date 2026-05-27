-- Can Grit Be Taught?
-- Professional positive psychology intervention-evaluation schema.
-- Synthetic-data scaffold only. Not for individual assessment.

CREATE TABLE IF NOT EXISTS grit_teachability_intervention (
    participant_id INTEGER PRIMARY KEY,
    age INTEGER,
    developmental_stage TEXT,
    condition TEXT,
    implementation_quality REAL,
    baseline_perseverance REAL,
    baseline_consistency REAL,
    baseline_adaptive_persistence REAL,
    baseline_support REAL,
    baseline_stress REAL,
    baseline_recovery REAL,
    baseline_burnout_risk REAL,
    post_perseverance REAL,
    post_consistency REAL,
    post_adaptive_persistence REAL,
    post_purpose_alignment REAL,
    post_feedback_responsiveness REAL,
    post_recovery_capacity REAL,
    post_burnout_risk REAL,
    post_wellbeing REAL,
    goal_progress REAL,
    intervention_acceptability REAL
);

CREATE VIEW IF NOT EXISTS grit_teachability_scored AS
SELECT
    participant_id,
    age,
    developmental_stage,
    condition,
    implementation_quality,
    (baseline_perseverance + baseline_consistency) / 2.0 AS baseline_grit_composite,
    (post_perseverance + post_consistency) / 2.0 AS post_grit_composite,
    ((post_perseverance + post_consistency) / 2.0) -
    ((baseline_perseverance + baseline_consistency) / 2.0) AS grit_change,
    post_adaptive_persistence - baseline_adaptive_persistence AS adaptive_persistence_change,
    post_burnout_risk - baseline_burnout_risk AS burnout_risk_change,
    baseline_support,
    baseline_stress,
    baseline_recovery,
    post_purpose_alignment,
    post_feedback_responsiveness,
    post_recovery_capacity,
    post_wellbeing,
    goal_progress,
    intervention_acceptability
FROM grit_teachability_intervention;

CREATE VIEW IF NOT EXISTS grit_teachability_condition_summary AS
SELECT
    condition,
    COUNT(*) AS n_participants,
    AVG(baseline_grit_composite) AS mean_baseline_grit,
    AVG(post_grit_composite) AS mean_post_grit,
    AVG(grit_change) AS mean_grit_change,
    AVG(adaptive_persistence_change) AS mean_adaptive_persistence_change,
    AVG(burnout_risk_change) AS mean_burnout_risk_change,
    AVG(post_wellbeing) AS mean_post_wellbeing,
    AVG(intervention_acceptability) AS mean_intervention_acceptability
FROM grit_teachability_scored
GROUP BY condition;
