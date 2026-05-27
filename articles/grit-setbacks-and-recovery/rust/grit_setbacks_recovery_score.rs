fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn recovery_capacity_score(
    emotional_recovery: f64,
    cognitive_recovery: f64,
    physical_restoration: f64,
    social_support: f64,
    practical_resources: f64,
) -> f64 {
    0.22 * emotional_recovery
        + 0.22 * cognitive_recovery
        + 0.18 * physical_restoration
        + 0.20 * social_support
        + 0.18 * practical_resources
}

fn adaptive_persistence_index(
    grit: f64,
    setback_severity: f64,
    recovery_capacity: f64,
    feedback_quality: f64,
    opportunity_access: f64,
    burnout: f64,
) -> f64 {
    0.18 * grit
        - 0.22 * setback_severity
        + 0.28 * recovery_capacity
        + 0.18 * feedback_quality
        + 0.18 * opportunity_access
        - 0.20 * burnout
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let recovery = recovery_capacity_score(0.74, 0.82, 0.66, 0.58, 0.62);
    let persistence = adaptive_persistence_index(grit, -0.28, recovery, 0.61, 0.70, -0.30);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic recovery capacity score: {:.3}", recovery);
    println!("Synthetic adaptive persistence index: {:.3}", persistence);
}
