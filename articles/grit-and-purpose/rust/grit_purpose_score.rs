fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn purpose_score(
    personal_meaning: f64,
    long_term_direction: f64,
    beyond_self_contribution: f64,
) -> f64 {
    0.34 * personal_meaning
        + 0.33 * long_term_direction
        + 0.33 * beyond_self_contribution
}

fn persistence_readiness_index(
    grit: f64,
    purpose: f64,
    social_support: f64,
    autonomy_support: f64,
    burnout: f64,
) -> f64 {
    0.22 * grit + 0.28 * purpose + 0.18 * social_support + 0.18 * autonomy_support - 0.18 * burnout
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let purpose = purpose_score(0.74, 0.82, 0.88);
    let readiness = persistence_readiness_index(grit, purpose, 0.58, 0.72, -0.30);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic purpose score: {:.3}", purpose);
    println!("Synthetic persistence readiness index: {:.3}", readiness);
}
