use std::time::Instant;

fn main() {
    let result = handler();
    println!("Handler result: {}", result);
}

#[no_mangle]
pub extern "C" fn handler() -> i32 {
    let start = Instant::now();
    // Simulate some work
    let result = (0..1000).fold(0, |acc, x| acc + x);
    let duration = start.elapsed();
    println!("Time elapsed in expensive_function() is: {:?}", duration);
    result
}

