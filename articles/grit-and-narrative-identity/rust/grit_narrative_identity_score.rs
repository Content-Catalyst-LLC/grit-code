fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn narrative_identity_score(
    narrative_coherence: f64,
    agency: f64,
    meaning_making: f64,
    future_orientation: f64,
) -> f64 {
    0.28 * narrative_coherence
        + 0.26 * agency
        + 0.24 * meaning_making
        + 0.22 * future_orientation
}

fn persistence_readiness_index(
    grit: f64,
    narrative_identity: f64,
    social_support: f64,
    institutional_trust: f64,
    burnout: f64,
    narrative_strain: f64,
) -> f64 {
    0.20 * grit
        + 0.26 * narrative_identity
        + 0.18 * social_support
        + 0.16 * institutional_trust
        - 0.16 * burnout
        - 0.12 * narrative_strain
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let narrative_identity = narrative_identity_score(0.76, 0.82, 0.70, 0.84);
    let readiness = persistence_readiness_index(grit, narrative_identity, 0.58, 0.72, -0.30, -0.28);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic narrative identity score: {:.3}", narrative_identity);
    println!("Synthetic persistence readiness index: {:.3}", readiness);
}
