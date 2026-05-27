-- Grit in Positive Psychology
-- SQL schema for synthetic grit and flourishing modeling.

CREATE TABLE IF NOT EXISTS grit_positive_psychology_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL NOT NULL,
    durable_interest REAL NOT NULL,
    grit_score REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort + 0.40 * durable_interest
    ) STORED,
    meaning REAL,
    relationships REAL,
    social_support REAL,
    health_resources REAL,
    depletion REAL,
    flourishing REAL
);

CREATE VIEW IF NOT EXISTS grit_positive_psychology_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(durable_interest) AS mean_durable_interest,
    AVG(grit_score) AS mean_grit_score,
    AVG(meaning) AS mean_meaning,
    AVG(relationships) AS mean_relationships,
    AVG(social_support) AS mean_social_support,
    AVG(health_resources) AS mean_health_resources,
    AVG(depletion) AS mean_depletion,
    AVG(flourishing) AS mean_flourishing
FROM grit_positive_psychology_observations;
