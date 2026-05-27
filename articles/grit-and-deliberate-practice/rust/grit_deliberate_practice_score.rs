fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn practice_quality_index(deliberate_practice: f64, feedback_quality: f64, coaching_access: f64) -> f64 {
    0.50 * deliberate_practice + 0.30 * feedback_quality + 0.20 * coaching_access
}

fn main() {
    let grit = grit_score(0.82, 0.64);
    let practice_quality = practice_quality_index(0.86, 0.61, 0.55);

    println!("Synthetic grit score: {:.3}", grit);
    println!("Synthetic practice quality index: {:.3}", practice_quality);
}
