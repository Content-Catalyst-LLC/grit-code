-- What Is Grit? — SQL schema for synthetic grit workflows

CREATE TABLE IF NOT EXISTS grit_synthetic_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL NOT NULL,
    consistency_interest REAL NOT NULL,
    grit_score REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort + 0.40 * consistency_interest
    ) STORED,
    conscientiousness REAL,
    social_support REAL,
    prior_achievement REAL,
    achievement_outcome REAL
);

CREATE VIEW IF NOT EXISTS grit_descriptive_view AS
SELECT
    COUNT(*) AS n_observations,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interest) AS mean_consistency_interest,
    AVG(grit_score) AS mean_grit_score,
    AVG(achievement_outcome) AS mean_achievement_outcome
FROM grit_synthetic_observations;
