-- Grit and Self-Control: Related but Not the Same
-- SQL schema for synthetic grit and self-control modeling.

CREATE TABLE IF NOT EXISTS grit_self_control_observations (
    id INTEGER PRIMARY KEY,
    attention_regulation REAL,
    emotion_regulation REAL,
    impulse_control REAL,
    self_control REAL GENERATED ALWAYS AS (
        0.40 * attention_regulation +
        0.30 * emotion_regulation +
        0.30 * impulse_control
    ) STORED,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    conscientiousness REAL,
    social_support REAL,
    prior_achievement REAL,
    burnout REAL,
    daily_task_completion REAL,
    long_term_goal_progress REAL
);

CREATE VIEW IF NOT EXISTS grit_self_control_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(self_control) AS mean_self_control,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interests) AS mean_consistency_interests,
    AVG(grit) AS mean_grit,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(social_support) AS mean_social_support,
    AVG(prior_achievement) AS mean_prior_achievement,
    AVG(burnout) AS mean_burnout,
    AVG(daily_task_completion) AS mean_daily_task_completion,
    AVG(long_term_goal_progress) AS mean_long_term_goal_progress
FROM grit_self_control_observations;

CREATE VIEW IF NOT EXISTS grit_self_control_profile_view AS
SELECT
    id,
    self_control,
    grit,
    CASE
        WHEN self_control >= 0 AND grit >= 0 THEN 'high_self_control_high_grit'
        WHEN self_control >= 0 AND grit < 0 THEN 'high_self_control_low_grit'
        WHEN self_control < 0 AND grit >= 0 THEN 'low_self_control_high_grit'
        ELSE 'low_self_control_low_grit'
    END AS profile,
    daily_task_completion,
    long_term_goal_progress
FROM grit_self_control_observations;
