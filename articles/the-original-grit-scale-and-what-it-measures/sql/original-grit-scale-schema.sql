-- The Original Grit Scale and What It Measures
-- SQL schema for synthetic grit measurement modeling.

CREATE TABLE IF NOT EXISTS original_grit_scale_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL NOT NULL,
    consistency_interest REAL NOT NULL,
    true_grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort + 0.40 * consistency_interest
    ) STORED,
    observed_grit_score REAL,
    measurement_error REAL,
    conscientiousness REAL,
    social_support REAL,
    prior_achievement REAL,
    long_term_outcome REAL
);

CREATE VIEW IF NOT EXISTS original_grit_scale_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interest) AS mean_consistency_interest,
    AVG(true_grit) AS mean_true_grit,
    AVG(observed_grit_score) AS mean_observed_grit_score,
    AVG(measurement_error) AS mean_measurement_error,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(social_support) AS mean_social_support,
    AVG(prior_achievement) AS mean_prior_achievement,
    AVG(long_term_outcome) AS mean_long_term_outcome
FROM original_grit_scale_observations;
