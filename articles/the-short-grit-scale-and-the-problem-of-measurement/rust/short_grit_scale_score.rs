fn grit_s_score(perseverance_effort: f64, consistency_interest: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interest
}

fn main() {
    println!(
        "Synthetic Short Grit Scale score: {:.3}",
        grit_s_score(0.74, 0.61)
    );
}
