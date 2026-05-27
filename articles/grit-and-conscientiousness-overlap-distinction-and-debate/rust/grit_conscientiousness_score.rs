fn conscientiousness_score(
    industriousness: f64,
    orderliness: f64,
    dependability: f64,
    responsibility: f64,
    achievement_striving: f64,
) -> f64 {
    0.30 * industriousness
        + 0.18 * orderliness
        + 0.18 * dependability
        + 0.17 * responsibility
        + 0.17 * achievement_striving
}

fn grit_score(perseverance_effort: f64, consistency_interests: f64) -> f64 {
    0.60 * perseverance_effort + 0.40 * consistency_interests
}

fn main() {
    let c = conscientiousness_score(0.81, 0.52, 0.67, 0.74, 0.79);
    let g = grit_score(0.91, 0.63);

    println!("Synthetic conscientiousness score: {:.3}", c);
    println!("Synthetic grit score: {:.3}", g);
}
