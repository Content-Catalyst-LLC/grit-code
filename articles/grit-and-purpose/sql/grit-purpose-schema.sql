-- Grit and Purpose
-- SQL schema for synthetic grit, purpose, and persistence modeling.

CREATE TABLE IF NOT EXISTS grit_purpose_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    personal_meaning REAL,
    long_term_direction REAL,
    beyond_self_contribution REAL,
    purpose REAL GENERATED ALWAYS AS (
        0.34 * personal_meaning +
        0.33 * long_term_direction +
        0.33 * beyond_self_contribution
    ) STORED,
    social_support REAL,
    feedback_quality REAL,
    opportunity_access REAL,
    autonomy_support REAL,
    health_stability REAL,
    burnout REAL,
    long_term_persistence REAL
);

CREATE VIEW IF NOT EXISTS grit_purpose_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(purpose) AS mean_purpose,
    AVG(personal_meaning) AS mean_personal_meaning,
    AVG(long_term_direction) AS mean_long_term_direction,
    AVG(beyond_self_contribution) AS mean_beyond_self_contribution,
    AVG(social_support) AS mean_social_support,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(opportunity_access) AS mean_opportunity_access,
    AVG(autonomy_support) AS mean_autonomy_support,
    AVG(health_stability) AS mean_health_stability,
    AVG(burnout) AS mean_burnout,
    AVG(long_term_persistence) AS mean_long_term_persistence
FROM grit_purpose_observations;

CREATE VIEW IF NOT EXISTS grit_purpose_profile_view AS
SELECT
    id,
    grit,
    purpose,
    social_support,
    autonomy_support,
    health_stability,
    burnout,
    long_term_persistence,
    CASE
        WHEN grit >= 0 AND purpose >= 0 THEN 'higher_grit_higher_purpose'
        WHEN grit >= 0 AND purpose < 0 THEN 'higher_grit_lower_purpose'
        WHEN grit < 0 AND purpose >= 0 THEN 'lower_grit_higher_purpose'
        ELSE 'lower_grit_lower_purpose'
    END AS grit_purpose_profile
FROM grit_purpose_observations;
