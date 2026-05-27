-- Angela Duckworth and the Modern Science of Grit
-- SQL schema for synthetic grit modeling.

CREATE TABLE IF NOT EXISTS duckworth_grit_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL NOT NULL,
    consistency_interest REAL NOT NULL,
    grit_score REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort + 0.40 * consistency_interest
    ) STORED,
    self_control REAL,
    conscientiousness REAL,
    social_support REAL,
    prior_achievement REAL,
    achievement_outcome REAL
);

CREATE VIEW IF NOT EXISTS duckworth_grit_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interest) AS mean_consistency_interest,
    AVG(grit_score) AS mean_grit_score,
    AVG(self_control) AS mean_self_control,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(social_support) AS mean_social_support,
    AVG(prior_achievement) AS mean_prior_achievement,
    AVG(achievement_outcome) AS mean_achievement_outcome
FROM duckworth_grit_observations;
