package main

import (
	"fmt"
	"math/rand"
	"time"
)

func currentTimeMillis() int64 {
	return time.Now().UnixNano() / int64(time.Millisecond)
}

func multiplyMatrices(a [][]float64, b [][]float64) [][]float64 {
	n := len(a)
	m := len(b[0])
	result := make([][]float64, n)
	for i := range result {
		result[i] = make([]float64, m)
	}

	for i := 0; i < n; i++ {
		for j := 0; j < m; j++ {
			for k := 0; k < len(a[0]); k++ {
				result[i][j] += a[i][k] * b[k][j]
			}
		}
	}

	return result
}

func main() {
	// Print the start time of the main function
	startTime := currentTimeMillis()
	fmt.Printf("Main function started at: %d ms\n", startTime)

	// Define matrix dimensions
	size := 500

	// Generate two random matrices
	a := make([][]float64, size)
	b := make([][]float64, size)

	rand.Seed(time.Now().UnixNano())

	for i := 0; i < size; i++ {
		a[i] = make([]float64, size)
		b[i] = make([]float64, size)
		for j := 0; j < size; j++ {
			a[i][j] = rand.Float64()
			b[i][j] = rand.Float64()
		}
	}

	start := time.Now()
	result := multiplyMatrices(a, b)
	duration := time.Since(start)

	// Just to prevent the compiler from optimizing away the computation
	var sum float64
	for _, row := range result {
		for _, value := range row {
			sum += value
		}
	}
	fmt.Printf("Sum of all elements: %f\n", sum)
	fmt.Printf("Time taken: %v\n", duration)
}

