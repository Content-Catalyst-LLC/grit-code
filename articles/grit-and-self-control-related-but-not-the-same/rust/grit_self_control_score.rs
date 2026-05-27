fn self_control_score(attention_regulation: f64, emotion_regulation: f64, impulse_control: f64) -> f64 {
    0.40 * attention_regulation + 0.30 * emotion_regulation + 0.30 * impulse_control
}

fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn main() {
    let sc = self_control_score(0.74, 0.62, 0.81);
    let g = grit_score(0.91, 0.68);

    println!("Synthetic self-control score: {:.3}", sc);
    println!("Synthetic grit score: {:.3}", g);
}
