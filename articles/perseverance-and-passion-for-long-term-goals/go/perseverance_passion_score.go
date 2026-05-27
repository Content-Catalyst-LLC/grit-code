package main

import "fmt"

func GritScore(perseveranceEffort float64, durablePassion float64) float64 {
	return 0.60*perseveranceEffort + 0.40*durablePassion
}

func main() {
	fmt.Printf("Synthetic perseverance-passion grit score: %.3f\n", GritScore(0.80, 0.65))
}
