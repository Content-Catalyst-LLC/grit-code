-- Professional positive psychology research schema.
-- Synthetic-data scaffold only. Not for individual assessment.

CREATE TABLE IF NOT EXISTS synthetic_positive_psychology_survey (
    participant_id INTEGER PRIMARY KEY,
    age INTEGER,
    developmental_stage TEXT,
    perseverance_item_1 INTEGER,
    perseverance_item_2 INTEGER,
    perseverance_item_3 INTEGER,
    perseverance_item_4 INTEGER,
    consistency_item_1 INTEGER,
    consistency_item_2 INTEGER,
    consistency_item_3 INTEGER,
    consistency_item_4 INTEGER,
    purpose_alignment REAL,
    feedback_responsiveness REAL,
    recovery_capacity REAL,
    social_support REAL,
    burnout_risk REAL,
    adaptive_persistence REAL,
    wellbeing REAL,
    goal_progress REAL
);

CREATE VIEW IF NOT EXISTS grit_facet_scores AS
SELECT
    participant_id,
    age,
    developmental_stage,
    (perseverance_item_1 + perseverance_item_2 + perseverance_item_3 + perseverance_item_4) / 4.0
        AS perseverance_score,
    (consistency_item_1 + consistency_item_2 + consistency_item_3 + consistency_item_4) / 4.0
        AS consistency_score,
    (
        perseverance_item_1 + perseverance_item_2 + perseverance_item_3 + perseverance_item_4 +
        consistency_item_1 + consistency_item_2 + consistency_item_3 + consistency_item_4
    ) / 8.0 AS grit_composite,
    purpose_alignment,
    feedback_responsiveness,
    recovery_capacity,
    social_support,
    burnout_risk,
    adaptive_persistence,
    wellbeing,
    goal_progress
FROM synthetic_positive_psychology_survey;

CREATE VIEW IF NOT EXISTS developmental_stage_summary AS
SELECT
    developmental_stage,
    COUNT(*) AS n_participants,
    AVG(perseverance_score) AS mean_perseverance_score,
    AVG(consistency_score) AS mean_consistency_score,
    AVG(grit_composite) AS mean_grit_composite,
    AVG(purpose_alignment) AS mean_purpose_alignment,
    AVG(recovery_capacity) AS mean_recovery_capacity,
    AVG(burnout_risk) AS mean_burnout_risk,
    AVG(adaptive_persistence) AS mean_adaptive_persistence,
    AVG(wellbeing) AS mean_wellbeing,
    AVG(goal_progress) AS mean_goal_progress
FROM grit_facet_scores
GROUP BY developmental_stage;
