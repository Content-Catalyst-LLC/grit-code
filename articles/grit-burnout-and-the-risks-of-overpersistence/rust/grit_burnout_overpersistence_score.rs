fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn overpersistence_index(
    grit: f64,
    sunk_cost: f64,
    identity_pressure: f64,
    goal_rigidity: f64,
    feedback_responsiveness: f64,
    goal_fit: f64,
) -> f64 {
    0.22 * grit
        + 0.24 * sunk_cost
        + 0.22 * identity_pressure
        + 0.20 * goal_rigidity
        - 0.22 * feedback_responsiveness
        - 0.20 * goal_fit
}

fn burnout_risk_index(
    demand_intensity: f64,
    overpersistence: f64,
    goal_rigidity: f64,
    grit: f64,
    recovery_capacity: f64,
    social_support: f64,
    autonomy: f64,
) -> f64 {
    0.24 * demand_intensity
        + 0.22 * overpersistence
        + 0.18 * goal_rigidity
        + 0.16 * grit
        - 0.26 * recovery_capacity
        - 0.20 * social_support
        - 0.18 * autonomy
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let overpersistence = overpersistence_index(grit, 0.38, 0.34, 0.30, 0.74, 0.80);
    let burnout = burnout_risk_index(0.42, overpersistence, 0.30, grit, 0.70, 0.62, 0.68);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic overpersistence index: {:.3}", overpersistence);
    println!("Synthetic burnout risk index: {:.3}", burnout);
}
