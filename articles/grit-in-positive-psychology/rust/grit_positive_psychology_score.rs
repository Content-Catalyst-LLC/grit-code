fn grit_score(perseverance_effort: f64, durable_interest: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * durable_interest
}

fn main() {
    println!(
        "Synthetic grit score for positive psychology model: {:.3}",
        grit_score(0.78, 0.66)
    );
}
