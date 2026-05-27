-- When Quitting Is Adaptive
-- SQL schema for synthetic adaptive quitting and reengagement modeling.

CREATE TABLE IF NOT EXISTS adaptive_quitting_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    cumulative_cost REAL,
    health_risk REAL,
    goal_misalignment REAL,
    opportunity_cost REAL,
    future_value REAL,
    learning_potential REAL,
    purpose_alignment REAL,
    social_support REAL,
    financial_security REAL,
    feedback_responsiveness REAL,
    sunk_cost REAL,
    identity_pressure REAL,
    alternative_meaning REAL,
    alternative_feasibility REAL,
    alternative_support REAL,
    transition_cost REAL,
    alternative_goal_value REAL,
    quitting_pressure REAL,
    overpersistence_risk REAL,
    adaptive_quitting_readiness REAL,
    sustainable_persistence REAL
);

CREATE VIEW IF NOT EXISTS adaptive_quitting_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(cumulative_cost) AS mean_cumulative_cost,
    AVG(health_risk) AS mean_health_risk,
    AVG(goal_misalignment) AS mean_goal_misalignment,
    AVG(opportunity_cost) AS mean_opportunity_cost,
    AVG(future_value) AS mean_future_value,
    AVG(learning_potential) AS mean_learning_potential,
    AVG(purpose_alignment) AS mean_purpose_alignment,
    AVG(social_support) AS mean_social_support,
    AVG(financial_security) AS mean_financial_security,
    AVG(feedback_responsiveness) AS mean_feedback_responsiveness,
    AVG(sunk_cost) AS mean_sunk_cost,
    AVG(identity_pressure) AS mean_identity_pressure,
    AVG(alternative_goal_value) AS mean_alternative_goal_value,
    AVG(quitting_pressure) AS mean_quitting_pressure,
    AVG(overpersistence_risk) AS mean_overpersistence_risk,
    AVG(adaptive_quitting_readiness) AS mean_adaptive_quitting_readiness,
    AVG(sustainable_persistence) AS mean_sustainable_persistence
FROM adaptive_quitting_observations;

CREATE VIEW IF NOT EXISTS adaptive_quitting_profile_view AS
SELECT
    id,
    grit,
    quitting_pressure,
    alternative_goal_value,
    overpersistence_risk,
    adaptive_quitting_readiness,
    sustainable_persistence,
    CASE
        WHEN quitting_pressure >= 0 AND alternative_goal_value >= 0 THEN 'higher_pressure_higher_alternative'
        WHEN quitting_pressure >= 0 AND alternative_goal_value < 0 THEN 'higher_pressure_lower_alternative'
        WHEN quitting_pressure < 0 AND alternative_goal_value >= 0 THEN 'lower_pressure_higher_alternative'
        ELSE 'lower_pressure_lower_alternative'
    END AS quitting_alternative_profile
FROM adaptive_quitting_observations;
