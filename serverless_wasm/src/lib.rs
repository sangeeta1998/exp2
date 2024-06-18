use std::time::Instant;

#[no_mangle]
pub extern "C" fn handler() -> i32 {
    let start = Instant::now();
    // Simulate some work
    let result = (0..1000).fold(0, |acc, x| acc + x);
    let duration = start.elapsed();
    println!("Time elapsed in function() is: {:?}", duration);
    result
}

#[no_mangle]
pub extern "C" fn _start() {
let result = handler();
    println!("Handler result: {}", result);
}
