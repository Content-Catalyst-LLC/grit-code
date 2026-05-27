-- Why Grit Still Matters
-- Professional positive psychology adaptive-persistence capstone schema.
-- Synthetic-data scaffold only. Not for individual assessment.

CREATE TABLE IF NOT EXISTS why_grit_still_matters_survey (
    participant_id INTEGER PRIMARY KEY,
    age INTEGER,
    developmental_stage TEXT,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit_composite REAL,
    self_control REAL,
    conscientiousness REAL,
    purpose_alignment REAL,
    feedback_quality REAL,
    practice_quality REAL,
    recovery_capacity REAL,
    environmental_support REAL,
    social_support REAL,
    autonomy_support REAL,
    chronic_stress REAL,
    demand_intensity REAL,
    blocked_opportunity REAL,
    adaptive_persistence REAL,
    goal_progress REAL,
    burnout_risk REAL,
    wellbeing REAL
);

CREATE VIEW IF NOT EXISTS why_grit_still_matters_scored AS
SELECT
    participant_id,
    age,
    developmental_stage,
    perseverance_effort,
    consistency_interests,
    (perseverance_effort + consistency_interests) / 2.0 AS grit_composite_calculated,
    grit_composite,
    self_control,
    conscientiousness,
    purpose_alignment,
    feedback_quality,
    practice_quality,
    recovery_capacity,
    environmental_support,
    social_support,
    autonomy_support,
    chronic_stress,
    demand_intensity,
    blocked_opportunity,
    adaptive_persistence,
    goal_progress,
    burnout_risk,
    wellbeing
FROM why_grit_still_matters_survey;

CREATE VIEW IF NOT EXISTS why_grit_still_matters_stage_summary AS
SELECT
    developmental_stage,
    COUNT(*) AS n_participants,
    AVG(grit_composite_calculated) AS mean_grit_composite,
    AVG(purpose_alignment) AS mean_purpose_alignment,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(recovery_capacity) AS mean_recovery_capacity,
    AVG(environmental_support) AS mean_environmental_support,
    AVG(social_support) AS mean_social_support,
    AVG(adaptive_persistence) AS mean_adaptive_persistence,
    AVG(goal_progress) AS mean_goal_progress,
    AVG(burnout_risk) AS mean_burnout_risk,
    AVG(wellbeing) AS mean_wellbeing
FROM why_grit_still_matters_scored
GROUP BY developmental_stage;
