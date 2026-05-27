fn grit_score(perseverance_effort: f64, durable_passion: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * durable_passion
}

fn main() {
    println!(
        "Synthetic perseverance-passion grit score: {:.3}",
        grit_score(0.80, 0.65)
    );
}
