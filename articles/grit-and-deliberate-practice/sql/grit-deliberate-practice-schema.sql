-- Grit and Deliberate Practice
-- SQL schema for synthetic practice-quality and performance modeling.

CREATE TABLE IF NOT EXISTS grit_deliberate_practice_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    feedback_quality REAL,
    coaching_access REAL,
    prior_skill REAL,
    social_support REAL,
    deliberate_practice REAL,
    burnout REAL,
    performance REAL
);

CREATE VIEW IF NOT EXISTS grit_deliberate_practice_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interests) AS mean_consistency_interests,
    AVG(deliberate_practice) AS mean_deliberate_practice,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(coaching_access) AS mean_coaching_access,
    AVG(prior_skill) AS mean_prior_skill,
    AVG(social_support) AS mean_social_support,
    AVG(burnout) AS mean_burnout,
    AVG(performance) AS mean_performance
FROM grit_deliberate_practice_observations;

CREATE VIEW IF NOT EXISTS grit_deliberate_practice_quality_view AS
SELECT
    id,
    grit,
    deliberate_practice,
    feedback_quality,
    coaching_access,
    prior_skill,
    social_support,
    burnout,
    performance,
    CASE
        WHEN deliberate_practice >= 0 AND feedback_quality >= 0 THEN 'higher_practice_higher_feedback'
        WHEN deliberate_practice >= 0 AND feedback_quality < 0 THEN 'higher_practice_lower_feedback'
        WHEN deliberate_practice < 0 AND feedback_quality >= 0 THEN 'lower_practice_higher_feedback'
        ELSE 'lower_practice_lower_feedback'
    END AS practice_feedback_profile
FROM grit_deliberate_practice_observations;
