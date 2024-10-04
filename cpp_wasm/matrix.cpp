#include <iostream>
#include <vector>
#include <chrono>

// Simple LCG for random number generation
unsigned int lcg() {
    static unsigned int seed = 123456789; // Initialize seed
    seed = (1103515245 * seed + 12345) % (1u << 31); // LCG formula
    return seed;
}

// Get current time in milliseconds
uint64_t current_time_millis() {
    return std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::system_clock::now().time_since_epoch()
    ).count();
}

// Function to multiply two matrices
std::vector<std::vector<double>> multiply_matrices(const std::vector<std::vector<double>>& a, const std::vector<std::vector<double>>& b) {
    int n = a.size();
    int m = b[0].size();
    std::vector<std::vector<double>> result(n, std::vector<double>(m, 0.0));

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
            for (int k = 0; k < a[0].size(); ++k) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return result;
}

int main() {
    // Print start time
    uint64_t start_time = current_time_millis();
    std::cout << "Main function started at: " << start_time << " ms\n";

    // Define matrix size
    const int size = 100;

    // Generate two random matrices
    std::vector<std::vector<double>> a(size, std::vector<double>(size));
    std::vector<std::vector<double>> b(size, std::vector<double>(size));

    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            a[i][j] = lcg() / static_cast<double>(UINT_MAX); // Use LCG for random numbers
            b[i][j] = lcg() / static_cast<double>(UINT_MAX);
        }
    }

    // Measure time to multiply matrices
    auto start = std::chrono::high_resolution_clock::now();
    auto result = multiply_matrices(a, b);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;

    // Output sum of elements to avoid optimization
    double sum = 0.0;
    for (const auto& row : result) {
        for (double val : row) {
            sum += val;
        }
    }

    std::cout << "Sum of all elements: " << sum << "\n";
    std::cout << "Time taken: " << duration.count() << " seconds\n";
    return 0;
}

