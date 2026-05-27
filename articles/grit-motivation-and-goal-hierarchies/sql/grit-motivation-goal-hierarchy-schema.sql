-- Grit, Motivation, and Goal Hierarchies
-- SQL schema for synthetic motivation, hierarchy, and progress modeling.

CREATE TABLE IF NOT EXISTS grit_goal_hierarchy_observations (
    id INTEGER PRIMARY KEY,
    perseverance_effort REAL,
    consistency_interests REAL,
    grit REAL GENERATED ALWAYS AS (
        0.60 * perseverance_effort +
        0.40 * consistency_interests
    ) STORED,
    intrinsic_interest REAL,
    identified_value REAL,
    purpose_orientation REAL,
    extrinsic_pressure REAL,
    motivation REAL GENERATED ALWAYS AS (
        0.30 * intrinsic_interest +
        0.30 * identified_value +
        0.30 * purpose_orientation +
        0.10 * extrinsic_pressure
    ) STORED,
    superordinate_clarity REAL,
    midlevel_planning REAL,
    daily_action_alignment REAL,
    goal_hierarchy_coherence REAL GENERATED ALWAYS AS (
        0.35 * superordinate_clarity +
        0.30 * midlevel_planning +
        0.35 * daily_action_alignment
    ) STORED,
    social_support REAL,
    feedback_quality REAL,
    burnout REAL,
    long_term_progress REAL
);

CREATE VIEW IF NOT EXISTS grit_goal_hierarchy_summary AS
SELECT
    COUNT(*) AS n_observations,
    AVG(grit) AS mean_grit,
    AVG(motivation) AS mean_motivation,
    AVG(goal_hierarchy_coherence) AS mean_goal_hierarchy_coherence,
    AVG(social_support) AS mean_social_support,
    AVG(feedback_quality) AS mean_feedback_quality,
    AVG(burnout) AS mean_burnout,
    AVG(long_term_progress) AS mean_long_term_progress
FROM grit_goal_hierarchy_observations;

CREATE VIEW IF NOT EXISTS grit_goal_hierarchy_profile_view AS
SELECT
    id,
    grit,
    motivation,
    goal_hierarchy_coherence,
    social_support,
    burnout,
    long_term_progress,
    CASE
        WHEN grit >= 0 AND goal_hierarchy_coherence >= 0 THEN 'higher_grit_higher_hierarchy_coherence'
        WHEN grit >= 0 AND goal_hierarchy_coherence < 0 THEN 'higher_grit_lower_hierarchy_coherence'
        WHEN grit < 0 AND goal_hierarchy_coherence >= 0 THEN 'lower_grit_higher_hierarchy_coherence'
        ELSE 'lower_grit_lower_hierarchy_coherence'
    END AS grit_hierarchy_profile
FROM grit_goal_hierarchy_observations;
