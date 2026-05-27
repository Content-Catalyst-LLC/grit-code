fn cohens_d(mean_treatment: f64, mean_control: f64, pooled_sd: f64) -> f64 {
    if pooled_sd == 0.0 {
        0.0
    } else {
        (mean_treatment - mean_control) / pooled_sd
    }
}

fn main() {
    let d = cohens_d(4.2, 3.6, 0.8);
    println!("Synthetic intervention effect size estimate: {:.3}", d);
    println!("Professional caution: synthetic demonstration only.");
}
