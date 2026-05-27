package main

import "fmt"

func GritScore(perseveranceEffort float64, durableInterest float64) float64 {
	return 0.60*perseveranceEffort + 0.40*durableInterest
}

func main() {
	fmt.Printf("Synthetic grit score for positive psychology model: %.3f\n", GritScore(0.78, 0.66))
}
