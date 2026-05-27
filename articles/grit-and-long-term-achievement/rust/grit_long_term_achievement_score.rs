fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn achievement_readiness_index(
    grit: f64,
    deliberate_practice: f64,
    feedback_quality: f64,
    social_support: f64,
    opportunity_access: f64,
    burnout: f64,
) -> f64 {
    0.18 * grit
        + 0.28 * deliberate_practice
        + 0.18 * feedback_quality
        + 0.18 * social_support
        + 0.22 * opportunity_access
        - 0.16 * burnout
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let readiness = achievement_readiness_index(grit, 0.86, 0.61, 0.58, 0.70, -0.28);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic achievement readiness index: {:.3}", readiness);
}
