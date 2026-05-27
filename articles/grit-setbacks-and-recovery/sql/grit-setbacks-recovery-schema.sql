-- Grit, Setbacks, and Recovery
-- SQL schema for synthetic setback and recovery modeling.

CREATE TABLE IF NOT EXISTS grit_setbacks_recovery_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    setback_severity REAL,
    emotional_recovery REAL,
    cognitive_recovery REAL,
    physical_restoration REAL,
    social_support REAL,
    practical_resources REAL,
    feedback_quality REAL,
    opportunity_access REAL,
    recovery_capacity REAL GENERATED ALWAYS AS (
        0.22 * emotional_recovery +
        0.22 * cognitive_recovery +
        0.18 * physical_restoration +
        0.20 * social_support +
        0.18 * practical_resources
    ) STORED,
    burnout REAL,
    adaptive_persistence REAL
);

CREATE VIEW IF NOT EXISTS grit_setbacks_recovery_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(setback_severity) AS mean_setback_severity,
    AVG(emotional_recovery) AS mean_emotional_recovery,
    AVG(cognitive_recovery) AS mean_cognitive_recovery,
    AVG(physical_restoration) AS mean_physical_restoration,
    AVG(social_support) AS mean_social_support,
    AVG(practical_resources) AS mean_practical_resources,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(opportunity_access) AS mean_opportunity_access,
    AVG(recovery_capacity) AS mean_recovery_capacity,
    AVG(burnout) AS mean_burnout,
    AVG(adaptive_persistence) AS mean_adaptive_persistence
FROM grit_setbacks_recovery_observations;

CREATE VIEW IF NOT EXISTS grit_recovery_profile_view AS
SELECT
    id,
    grit,
    setback_severity,
    recovery_capacity,
    emotional_recovery,
    cognitive_recovery,
    social_support,
    feedback_quality,
    burnout,
    adaptive_persistence,
    CASE
        WHEN grit >= 0 AND recovery_capacity >= 0 THEN 'higher_grit_higher_recovery'
        WHEN grit >= 0 AND recovery_capacity < 0 THEN 'higher_grit_lower_recovery'
        WHEN grit < 0 AND recovery_capacity >= 0 THEN 'lower_grit_higher_recovery'
        ELSE 'lower_grit_lower_recovery'
    END AS grit_recovery_profile
FROM grit_setbacks_recovery_observations;
