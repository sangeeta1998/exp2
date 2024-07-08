use std::time::Instant;
use rand::random;

fn multiply_matrices(a: &Vec<Vec<f64>>, b: &Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    let n = a.len();
    let m = b[0].len();
    let mut result = vec![vec![0.0; m]; n];

    for i in 0..n {
        for j in 0..m {
            for k in 0..a[0].len() {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }

    result
}

fn main() {
    // Define matrix dimensions
    let size = 500;

    // Generate two random matrices
    let mut a = vec![vec![0.0; size]; size];
    let mut b = vec![vec![0.0; size]; size];

    for i in 0..size {
        for j in 0..size {
            a[i][j] = random::<f64>();
            b[i][j] = random::<f64>();
        }
    }

    let start = Instant::now();
    let result = multiply_matrices(&a, &b);
    let duration = start.elapsed();

    // Just to prevent the compiler from optimizing away the computation
    let sum: f64 = result.iter().flat_map(|row| row.iter()).sum();
    println!("Sum of all elements: {}", sum);
    println!("Time taken: {:?}", duration);
}

