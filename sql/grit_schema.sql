-- Root schema for grit, sustained striving, goal continuity, recovery, and friction data.

CREATE TABLE IF NOT EXISTS participants (
    participant_id TEXT PRIMARY KEY,
    age_years REAL,
    birth_cohort INTEGER,
    language_background TEXT,
    context_label TEXT,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS goals (
    goal_id TEXT PRIMARY KEY,
    participant_id TEXT NOT NULL,
    goal_name TEXT NOT NULL,
    superordinate_goal TEXT,
    start_date TEXT,
    current_status TEXT,
    meaning_alignment REAL,
    goal_fit REAL
);

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
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
