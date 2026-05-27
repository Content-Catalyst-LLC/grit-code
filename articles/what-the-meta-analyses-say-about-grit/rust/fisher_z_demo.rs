fn fisher_z(r: f64) -> f64 {
    0.5 * ((1.0 + r) / (1.0 - r)).ln()
}

fn inverse_fisher_z(z: f64) -> f64 {
    let e = (2.0 * z).exp();
    (e - 1.0) / (e + 1.0)
}

fn main() {
    let r = 0.22;
    let z = fisher_z(r);
    println!("r: {:.3}", r);
    println!("Fisher z: {:.3}", z);
    println!("Back-transformed r: {:.3}", inverse_fisher_z(z));
}
