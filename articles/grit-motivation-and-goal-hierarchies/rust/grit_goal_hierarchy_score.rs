fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn motivation_score(
    intrinsic_interest: f64,
    identified_value: f64,
    purpose_orientation: f64,
    extrinsic_pressure: f64,
) -> f64 {
    0.30 * intrinsic_interest
        + 0.30 * identified_value
        + 0.30 * purpose_orientation
        + 0.10 * extrinsic_pressure
}

fn hierarchy_coherence_score(
    superordinate_clarity: f64,
    midlevel_planning: f64,
    daily_action_alignment: f64,
) -> f64 {
    0.35 * superordinate_clarity
        + 0.30 * midlevel_planning
        + 0.35 * daily_action_alignment
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let motivation = motivation_score(0.71, 0.78, 0.84, 0.25);
    let hierarchy = hierarchy_coherence_score(0.86, 0.74, 0.69);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic motivation score: {:.3}", motivation);
    println!("Synthetic goal-hierarchy coherence score: {:.3}", hierarchy);
}
