-- Grit and Long-Term Achievement
-- SQL schema for synthetic achievement trajectory modeling.

CREATE TABLE IF NOT EXISTS grit_long_term_achievement_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    prior_preparation REAL,
    deliberate_practice REAL,
    feedback_quality REAL,
    social_support REAL,
    opportunity_access REAL,
    health_stability REAL,
    burnout REAL,
    long_term_achievement REAL
);

CREATE VIEW IF NOT EXISTS grit_long_term_achievement_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interests) AS mean_consistency_interests,
    AVG(prior_preparation) AS mean_prior_preparation,
    AVG(deliberate_practice) AS mean_deliberate_practice,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(social_support) AS mean_social_support,
    AVG(opportunity_access) AS mean_opportunity_access,
    AVG(health_stability) AS mean_health_stability,
    AVG(burnout) AS mean_burnout,
    AVG(long_term_achievement) AS mean_long_term_achievement
FROM grit_long_term_achievement_observations;

CREATE VIEW IF NOT EXISTS grit_opportunity_profile_view AS
SELECT
    id,
    grit,
    opportunity_access,
    social_support,
    health_stability,
    burnout,
    long_term_achievement,
    CASE
        WHEN grit >= 0 AND opportunity_access >= 0 THEN 'higher_grit_higher_opportunity'
        WHEN grit >= 0 AND opportunity_access < 0 THEN 'higher_grit_lower_opportunity'
        WHEN grit < 0 AND opportunity_access >= 0 THEN 'lower_grit_higher_opportunity'
        ELSE 'lower_grit_lower_opportunity'
    END AS grit_opportunity_profile
FROM grit_long_term_achievement_observations;
