fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn persistence_readiness_index(
    grit: f64,
    self_control: f64,
    belonging: f64,
    social_support: f64,
    financial_stress: f64,
    burnout: f64,
) -> f64 {
    0.22 * grit
        + 0.18 * self_control
        + 0.22 * belonging
        + 0.18 * social_support
        - 0.20 * financial_stress
        - 0.18 * burnout
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let readiness = persistence_readiness_index(grit, 0.72, 0.74, 0.58, -0.42, -0.30);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic academic persistence readiness index: {:.3}", readiness);
}
