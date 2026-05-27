-- Situational Supports for Sustained Effort
-- Professional positive psychology research schema.
-- Synthetic-data scaffold only. Not for individual assessment.

CREATE TABLE IF NOT EXISTS situational_supports_survey (
    participant_id INTEGER PRIMARY KEY,
    age INTEGER,
    developmental_stage TEXT,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit_composite REAL,
    autonomy_support REAL,
    feedback_quality REAL,
    belonging REAL,
    mentoring_access REAL,
    recovery_capacity REAL,
    material_resources REAL,
    fairness REAL,
    psychological_safety REAL,
    chronic_stress REAL,
    blocked_opportunity REAL,
    adaptive_persistence REAL,
    burnout_risk REAL,
    goal_progress REAL,
    wellbeing REAL
);

CREATE VIEW IF NOT EXISTS situational_supports_scored AS
SELECT
    participant_id,
    age,
    developmental_stage,
    perseverance_effort,
    consistency_interests,
    grit_composite,
    (
        autonomy_support +
        feedback_quality +
        belonging +
        mentoring_access +
        recovery_capacity +
        material_resources +
        fairness +
        psychological_safety
    ) / 8.0 AS situational_support_composite,
    autonomy_support,
    feedback_quality,
    belonging,
    mentoring_access,
    recovery_capacity,
    material_resources,
    fairness,
    psychological_safety,
    chronic_stress,
    blocked_opportunity,
    adaptive_persistence,
    burnout_risk,
    goal_progress,
    wellbeing
FROM situational_supports_survey;

CREATE VIEW IF NOT EXISTS situational_supports_stage_summary AS
SELECT
    developmental_stage,
    COUNT(*) AS n_participants,
    AVG(grit_composite) AS mean_grit_composite,
    AVG(situational_support_composite) AS mean_situational_support,
    AVG(adaptive_persistence) AS mean_adaptive_persistence,
    AVG(burnout_risk) AS mean_burnout_risk,
    AVG(goal_progress) AS mean_goal_progress,
    AVG(wellbeing) AS mean_wellbeing,
    AVG(chronic_stress) AS mean_chronic_stress,
    AVG(blocked_opportunity) AS mean_blocked_opportunity
FROM situational_supports_scored
GROUP BY developmental_stage;
