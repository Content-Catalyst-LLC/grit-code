CREATE TABLE IF NOT EXISTS grit_development_observations (
    person_id INTEGER,
    wave INTEGER,
    age INTEGER,
    stage TEXT,
    support REAL,
    feedback_quality REAL,
    purpose REAL,
    recovery_capacity REAL,
    chronic_stress REAL,
    opportunity_access REAL,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL,
    adaptive_persistence REAL
);

CREATE VIEW IF NOT EXISTS grit_development_stage_summary AS
SELECT
    stage,
    COUNT(*) AS n_observations,
    AVG(age) AS mean_age,
    AVG(perseverance_effort) AS mean_perseverance_effort,
    AVG(consistency_interests) AS mean_consistency_interests,
    AVG(grit) AS mean_grit,
    AVG(adaptive_persistence) AS mean_adaptive_persistence,
    AVG(support) AS mean_support,
    AVG(purpose) AS mean_purpose,
    AVG(chronic_stress) AS mean_chronic_stress
FROM grit_development_observations
GROUP BY stage;
