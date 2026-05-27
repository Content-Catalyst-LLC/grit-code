-- Grit and Conscientiousness: Overlap, Distinction, and Debate
-- SQL schema for synthetic construct-overlap modeling.

CREATE TABLE IF NOT EXISTS grit_conscientiousness_observations (
    id INTEGER PRIMARY KEY,
    industriousness REAL,
    orderliness REAL,
    dependability REAL,
    responsibility REAL,
    achievement_striving REAL,
    conscientiousness REAL GENERATED ALWAYS AS (
        0.30 * industriousness +
        0.18 * orderliness +
        0.18 * dependability +
        0.17 * responsibility +
        0.17 * achievement_striving
    ) STORED,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    prior_achievement REAL,
    social_support REAL,
    burnout REAL,
    long_term_progress REAL
);

CREATE VIEW IF NOT EXISTS grit_conscientiousness_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(grit) AS mean_grit,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interests) AS mean_consistency_interests,
    AVG(industriousness) AS mean_industriousness,
    AVG(achievement_striving) AS mean_achievement_striving,
    AVG(prior_achievement) AS mean_prior_achievement,
    AVG(social_support) AS mean_social_support,
    AVG(burnout) AS mean_burnout,
    AVG(long_term_progress) AS mean_long_term_progress
FROM grit_conscientiousness_observations;

CREATE VIEW IF NOT EXISTS grit_conscientiousness_profile_view AS
SELECT
    id,
    conscientiousness,
    grit,
    CASE
        WHEN conscientiousness >= 0 AND grit >= 0 THEN 'high_conscientiousness_high_grit'
        WHEN conscientiousness >= 0 AND grit < 0 THEN 'high_conscientiousness_low_grit'
        WHEN conscientiousness < 0 AND grit >= 0 THEN 'low_conscientiousness_high_grit'
        ELSE 'low_conscientiousness_low_grit'
    END AS profile,
    long_term_progress
FROM grit_conscientiousness_observations;
