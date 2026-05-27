package main

import "fmt"

func GritScore(perseveranceEffort float64, consistencyInterest float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterest
}

func main() {
	fmt.Printf("Duckworth-style synthetic grit score: %.3f\n", GritScore(0.82, 0.61))
}
