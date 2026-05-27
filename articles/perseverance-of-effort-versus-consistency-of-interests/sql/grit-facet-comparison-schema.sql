-- Perseverance of Effort Versus Consistency of Interests
-- SQL schema for synthetic grit-facet modeling.

CREATE TABLE IF NOT EXISTS grit_facet_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL NOT NULL,
    consistency_interests REAL NOT NULL,
    grit_total REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort + 0.40 * consistency_interests
    ) STORED,
    conscientiousness REAL,
    self_control REAL,
    social_support REAL,
    prior_achievement REAL,
    burnout REAL,
    long_term_outcome REAL
);

CREATE VIEW IF NOT EXISTS grit_facet_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interests) AS mean_consistency_interests,
    AVG(grit_total) AS mean_grit_total,
    AVG(conscientiousness) AS mean_conscientiousness,
    AVG(self_control) AS mean_self_control,
    AVG(social_support) AS mean_social_support,
    AVG(prior_achievement) AS mean_prior_achievement,
    AVG(burnout) AS mean_burnout,
    AVG(long_term_outcome) AS mean_long_term_outcome
FROM grit_facet_observations;

CREATE VIEW IF NOT EXISTS grit_facet_profile_view AS
SELECT
    id,
    perseverance_effort,
    consistency_interests,
    grit_total,
    CASE
        WHEN perseverance_effort >= 0 AND consistency_interests >= 0 THEN 'high_effort_high_consistency'
        WHEN perseverance_effort >= 0 AND consistency_interests < 0 THEN 'high_effort_low_consistency'
        WHEN perseverance_effort < 0 AND consistency_interests >= 0 THEN 'low_effort_high_consistency'
        ELSE 'low_effort_low_consistency'
    END AS facet_profile,
    long_term_outcome
FROM grit_facet_observations;
