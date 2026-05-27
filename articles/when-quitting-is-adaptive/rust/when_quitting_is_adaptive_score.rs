fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn quitting_pressure_index(
    cumulative_cost: f64,
    health_risk: f64,
    goal_misalignment: f64,
    opportunity_cost: f64,
    future_value: f64,
    learning_potential: f64,
    purpose_alignment: f64,
) -> f64 {
    0.24 * cumulative_cost
        + 0.26 * health_risk
        + 0.24 * goal_misalignment
        + 0.20 * opportunity_cost
        - 0.24 * future_value
        - 0.20 * learning_potential
        - 0.24 * purpose_alignment
}

fn alternative_goal_value_index(
    alternative_meaning: f64,
    alternative_feasibility: f64,
    alternative_support: f64,
    transition_cost: f64,
) -> f64 {
    0.30 * alternative_meaning
        + 0.28 * alternative_feasibility
        + 0.24 * alternative_support
        - 0.18 * transition_cost
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let quitting_pressure = quitting_pressure_index(0.22, 0.18, 0.10, 0.20, 0.76, 0.72, 0.82);
    let alternative_value = alternative_goal_value_index(0.70, 0.62, 0.78, 0.28);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic quitting pressure index: {:.3}", quitting_pressure);
    println!("Synthetic alternative goal value index: {:.3}", alternative_value);
}
