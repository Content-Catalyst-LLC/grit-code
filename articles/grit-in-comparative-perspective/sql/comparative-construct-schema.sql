-- Grit in Comparative Perspective
-- Professional positive psychology comparative construct schema.
-- Synthetic-data scaffold only. Not for individual assessment.

CREATE TABLE IF NOT EXISTS grit_comparative_construct_survey (
    participant_id INTEGER PRIMARY KEY,
    age INTEGER,
    developmental_stage TEXT,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit_composite REAL,
    self_control REAL,
    conscientiousness REAL,
    resilience_recovery REAL,
    deliberate_practice_quality REAL,
    motivation_quality REAL,
    purpose_alignment REAL,
    growth_mindset REAL,
    narrative_identity_flexibility REAL,
    environmental_support REAL,
    autonomy_support REAL,
    chronic_stress REAL,
    demand_intensity REAL,
    adaptive_persistence REAL,
    goal_progress REAL,
    burnout_risk REAL,
    wellbeing REAL
);

CREATE VIEW IF NOT EXISTS grit_comparative_construct_scored AS
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
    resilience_recovery,
    deliberate_practice_quality,
    motivation_quality,
    purpose_alignment,
    growth_mindset,
    narrative_identity_flexibility,
    environmental_support,
    autonomy_support,
    chronic_stress,
    demand_intensity,
    adaptive_persistence,
    goal_progress,
    burnout_risk,
    wellbeing
FROM grit_comparative_construct_survey;

CREATE VIEW IF NOT EXISTS grit_comparative_construct_stage_summary AS
SELECT
    developmental_stage,
    COUNT(*) AS n_participants,
    AVG(grit_composite_calculated) AS mean_grit_composite,
    AVG(self_control) AS mean_self_control,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(resilience_recovery) AS mean_resilience_recovery,
    AVG(deliberate_practice_quality) AS mean_practice_quality,
    AVG(purpose_alignment) AS mean_purpose_alignment,
    AVG(environmental_support) AS mean_environmental_support,
    AVG(adaptive_persistence) AS mean_adaptive_persistence,
    AVG(goal_progress) AS mean_goal_progress,
    AVG(burnout_risk) AS mean_burnout_risk,
    AVG(wellbeing) AS mean_wellbeing
FROM grit_comparative_construct_scored
GROUP BY developmental_stage;
