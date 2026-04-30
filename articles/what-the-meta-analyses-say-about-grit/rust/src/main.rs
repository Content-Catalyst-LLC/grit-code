fn grit_score(perseverance: f64, interest: f64, recovery: f64, disengagement_pressure: f64) -> f64 {
    0.40 * perseverance + 0.30 * interest + 0.20 * recovery - 0.20 * disengagement_pressure
}

fn main() {
    let score = grit_score(0.80, 0.65, 0.70, 0.25);
    println!("Toy grit score: {:.3}", score);
}
