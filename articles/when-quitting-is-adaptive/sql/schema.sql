-- Article-level synthetic grit schema.

CREATE TABLE IF NOT EXISTS grit_observations (
    observation_id INTEGER PRIMARY KEY,
    participant_id TEXT NOT NULL,
    goal_id TEXT,
    wave INTEGER NOT NULL,
    perseverance REAL,
    interest_consistency REAL,
    recovery_capacity REAL,
    self_control_support REAL,
    meaning_alignment REAL,
    support_index REAL,
    friction_load REAL,
    burnout_risk REAL,
    adaptive_disengagement_signal REAL,
    weekly_progress REAL,
    cumulative_progress REAL
);

CREATE INDEX IF NOT EXISTS idx_grit_participant
ON grit_observations(participant_id);

CREATE INDEX IF NOT EXISTS idx_grit_wave
ON grit_observations(wave);

CREATE INDEX IF NOT EXISTS idx_grit_goal
ON grit_observations(goal_id);
