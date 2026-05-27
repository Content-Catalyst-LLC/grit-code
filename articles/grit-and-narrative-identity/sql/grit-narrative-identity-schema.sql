-- Grit and Narrative Identity
-- SQL schema for synthetic grit, narrative identity, and persistence modeling.

CREATE TABLE IF NOT EXISTS grit_narrative_identity_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    narrative_coherence REAL,
    agency REAL,
    meaning_making REAL,
    future_orientation REAL,
    narrative_identity REAL GENERATED ALWAYS AS (
        0.28 * narrative_coherence +
        0.26 * agency +
        0.24 * meaning_making +
        0.22 * future_orientation
    ) STORED,
    social_support REAL,
    feedback_quality REAL,
    opportunity_access REAL,
    health_stability REAL,
    institutional_trust REAL,
    burnout REAL,
    narrative_strain REAL,
    long_term_persistence REAL
);

CREATE VIEW IF NOT EXISTS grit_narrative_identity_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(narrative_identity) AS mean_narrative_identity,
    AVG(narrative_coherence) AS mean_narrative_coherence,
    AVG(agency) AS mean_agency,
    AVG(meaning_making) AS mean_meaning_making,
    AVG(future_orientation) AS mean_future_orientation,
    AVG(social_support) AS mean_social_support,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(opportunity_access) AS mean_opportunity_access,
    AVG(health_stability) AS mean_health_stability,
    AVG(institutional_trust) AS mean_institutional_trust,
    AVG(burnout) AS mean_burnout,
    AVG(narrative_strain) AS mean_narrative_strain,
    AVG(long_term_persistence) AS mean_long_term_persistence
FROM grit_narrative_identity_observations;

CREATE VIEW IF NOT EXISTS grit_narrative_identity_profile_view AS
SELECT
    id,
    grit,
    narrative_identity,
    agency,
    meaning_making,
    future_orientation,
    social_support,
    institutional_trust,
    burnout,
    narrative_strain,
    long_term_persistence,
    CASE
        WHEN grit >= 0 AND narrative_identity >= 0 THEN 'higher_grit_higher_narrative_identity'
        WHEN grit >= 0 AND narrative_identity < 0 THEN 'higher_grit_lower_narrative_identity'
        WHEN grit < 0 AND narrative_identity >= 0 THEN 'lower_grit_higher_narrative_identity'
        ELSE 'lower_grit_lower_narrative_identity'
    END AS grit_narrative_profile
FROM grit_narrative_identity_observations;
