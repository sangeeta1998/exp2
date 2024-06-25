use std::time::Instant;

fn main() {
    let result = handler();
    println!("Handler result: {}", result);
}

#[no_mangle]
pub extern "C" fn handler() -> i32 {
    let start = Instant::now();
    let result = (0..1000).fold(0, |acc, x| acc + x);
    let duration = start.elapsed();
    let millis = duration.as_millis();
    println!("Time elapsed in function() is: {} ms", millis);
    result
}

