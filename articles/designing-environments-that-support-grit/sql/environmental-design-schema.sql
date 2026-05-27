-- Designing Environments That Support Grit
-- Professional positive psychology environmental-design research schema.
-- Synthetic-data scaffold only. Not for individual assessment.

CREATE TABLE IF NOT EXISTS grit_supportive_environment_survey (
    participant_id INTEGER PRIMARY KEY,
    age INTEGER,
    developmental_stage TEXT,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit_composite REAL,
    autonomy_support REAL,
    competence_support REAL,
    feedback_quality REAL,
    belonging REAL,
    mentoring_access REAL,
    recovery_design REAL,
    material_resources REAL,
    fairness REAL,
    psychological_safety REAL,
    adaptive_quitting_norms REAL,
    chronic_stress REAL,
    blocked_opportunity REAL,
    environment_design_composite REAL,
    adaptive_persistence REAL,
    burnout_risk REAL,
    goal_progress REAL,
    wellbeing REAL
);

CREATE VIEW IF NOT EXISTS grit_supportive_environment_scored AS
SELECT
    participant_id,
    age,
    developmental_stage,
    perseverance_effort,
    consistency_interests,
    grit_composite,
    (
        autonomy_support +
        competence_support +
        feedback_quality +
        belonging +
        mentoring_access +
        recovery_design +
        material_resources +
        fairness +
        psychological_safety +
        adaptive_quitting_norms
    ) / 10.0 AS environment_design_composite_calculated,
    autonomy_support,
    competence_support,
    feedback_quality,
    belonging,
    mentoring_access,
    recovery_design,
    material_resources,
    fairness,
    psychological_safety,
    adaptive_quitting_norms,
    chronic_stress,
    blocked_opportunity,
    adaptive_persistence,
    burnout_risk,
    goal_progress,
    wellbeing
FROM grit_supportive_environment_survey;

CREATE VIEW IF NOT EXISTS grit_supportive_environment_stage_summary AS
SELECT
    developmental_stage,
    COUNT(*) AS n_participants,
    AVG(grit_composite) AS mean_grit_composite,
    AVG(environment_design_composite_calculated) AS mean_environment_design,
    AVG(adaptive_persistence) AS mean_adaptive_persistence,
    AVG(burnout_risk) AS mean_burnout_risk,
    AVG(goal_progress) AS mean_goal_progress,
    AVG(wellbeing) AS mean_wellbeing,
    AVG(chronic_stress) AS mean_chronic_stress,
    AVG(blocked_opportunity) AS mean_blocked_opportunity
FROM grit_supportive_environment_scored
GROUP BY developmental_stage;
