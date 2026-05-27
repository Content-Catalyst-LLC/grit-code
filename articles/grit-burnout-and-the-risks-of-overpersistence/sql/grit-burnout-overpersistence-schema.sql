-- Grit, Burnout, and the Risks of Overpersistence
-- SQL schema for synthetic overpersistence and burnout-risk modeling.

CREATE TABLE IF NOT EXISTS grit_burnout_overpersistence_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    demand_intensity REAL,
    goal_rigidity REAL,
    identity_pressure REAL,
    sunk_cost REAL,
    recovery_capacity REAL,
    social_support REAL,
    autonomy REAL,
    feedback_responsiveness REAL,
    goal_fit REAL,
    overpersistence REAL,
    burnout_risk REAL,
    sustainable_persistence REAL
);

CREATE VIEW IF NOT EXISTS grit_burnout_overpersistence_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(demand_intensity) AS mean_demand_intensity,
    AVG(goal_rigidity) AS mean_goal_rigidity,
    AVG(identity_pressure) AS mean_identity_pressure,
    AVG(sunk_cost) AS mean_sunk_cost,
    AVG(recovery_capacity) AS mean_recovery_capacity,
    AVG(social_support) AS mean_social_support,
    AVG(autonomy) AS mean_autonomy,
    AVG(feedback_responsiveness) AS mean_feedback_responsiveness,
    AVG(goal_fit) AS mean_goal_fit,
    AVG(overpersistence) AS mean_overpersistence,
    AVG(burnout_risk) AS mean_burnout_risk,
    AVG(sustainable_persistence) AS mean_sustainable_persistence
FROM grit_burnout_overpersistence_observations;

CREATE VIEW IF NOT EXISTS grit_burnout_profile_view AS
SELECT
    id,
    grit,
    recovery_capacity,
    demand_intensity,
    goal_rigidity,
    identity_pressure,
    sunk_cost,
    overpersistence,
    burnout_risk,
    sustainable_persistence,
    CASE
        WHEN grit >= 0 AND recovery_capacity >= 0 THEN 'higher_grit_higher_recovery'
        WHEN grit >= 0 AND recovery_capacity < 0 THEN 'higher_grit_lower_recovery'
        WHEN grit < 0 AND recovery_capacity >= 0 THEN 'lower_grit_higher_recovery'
        ELSE 'lower_grit_lower_recovery'
    END AS grit_recovery_profile
FROM grit_burnout_overpersistence_observations;
