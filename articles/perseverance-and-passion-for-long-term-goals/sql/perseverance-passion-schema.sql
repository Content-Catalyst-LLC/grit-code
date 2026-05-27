-- Perseverance and Passion for Long-Term Goals
-- SQL schema for synthetic grit modeling.

CREATE TABLE IF NOT EXISTS perseverance_passion_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL NOT NULL,
    durable_passion REAL NOT NULL,
    grit_score REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort + 0.40 * durable_passion
    ) STORED,
    conscientiousness REAL,
    social_support REAL,
    prior_achievement REAL,
    long_term_outcome REAL
);

CREATE VIEW IF NOT EXISTS perseverance_passion_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(durable_passion) AS mean_durable_passion,
    AVG(grit_score) AS mean_grit_score,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(social_support) AS mean_social_support,
    AVG(prior_achievement) AS mean_prior_achievement,
    AVG(long_term_outcome) AS mean_long_term_outcome
FROM perseverance_passion_observations;
