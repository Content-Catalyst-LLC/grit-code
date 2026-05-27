fn grit_total_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn main() {
    println!(
        "Synthetic grit total score: {:.3}",
        grit_total_score(0.82, 0.71)
    );
}
