-- What the Meta-Analyses Say About Grit
-- SQL schema for synthetic study-level grit meta-analysis data.

CREATE TABLE IF NOT EXISTS grit_meta_analysis_studies (
    study_id TEXT PRIMARY KEY,
    sample_size INTEGER NOT NULL,
    r_total_grit REAL,
    r_perseverance REAL,
    r_consistency REAL,
    outcome_domain TEXT
);

CREATE VIEW IF NOT EXISTS grit_meta_analysis_domain_summary AS
SELECT
    outcome_domain,
    COUNT(*) AS k_studies,
    AVG(sample_size) AS mean_sample_size,
    AVG(r_total_grit) AS mean_r_total_grit,
    AVG(r_perseverance) AS mean_r_perseverance,
    AVG(r_consistency) AS mean_r_consistency
FROM grit_meta_analysis_studies
GROUP BY outcome_domain;

CREATE VIEW IF NOT EXISTS grit_meta_analysis_overall_summary AS
SELECT
    COUNT(*) AS k_studies,
    AVG(sample_size) AS mean_sample_size,
    AVG(r_total_grit) AS mean_r_total_grit,
    AVG(r_perseverance) AS mean_r_perseverance,
    AVG(r_consistency) AS mean_r_consistency
FROM grit_meta_analysis_studies;
