-- Grit and Academic Persistence
-- SQL schema for synthetic academic persistence modeling.

CREATE TABLE IF NOT EXISTS grit_academic_persistence_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    self_control REAL,
    prior_preparation REAL,
    instructional_quality REAL,
    feedback_quality REAL,
    belonging REAL,
    social_support REAL,
    financial_stress REAL,
    health_stability REAL,
    study_effort REAL,
    burnout REAL,
    academic_progress REAL,
    academic_persistence REAL
);

CREATE VIEW IF NOT EXISTS grit_academic_persistence_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(self_control) AS mean_self_control,
    AVG(prior_preparation) AS mean_prior_preparation,
    AVG(instructional_quality) AS mean_instructional_quality,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(belonging) AS mean_belonging,
    AVG(social_support) AS mean_social_support,
    AVG(financial_stress) AS mean_financial_stress,
    AVG(health_stability) AS mean_health_stability,
    AVG(study_effort) AS mean_study_effort,
    AVG(burnout) AS mean_burnout,
    AVG(academic_progress) AS mean_academic_progress,
    AVG(academic_persistence) AS mean_academic_persistence
FROM grit_academic_persistence_observations;

CREATE VIEW IF NOT EXISTS grit_belonging_profile_view AS
SELECT
    id,
    grit,
    belonging,
    social_support,
    financial_stress,
    burnout,
    academic_progress,
    academic_persistence,
    CASE
        WHEN grit >= 0 AND belonging >= 0 THEN 'higher_grit_higher_belonging'
        WHEN grit >= 0 AND belonging < 0 THEN 'higher_grit_lower_belonging'
        WHEN grit < 0 AND belonging >= 0 THEN 'lower_grit_higher_belonging'
        ELSE 'lower_grit_lower_belonging'
    END AS grit_belonging_profile
FROM grit_academic_persistence_observations;
