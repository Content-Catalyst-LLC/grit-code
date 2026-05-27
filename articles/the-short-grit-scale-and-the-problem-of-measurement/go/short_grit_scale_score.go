package main

import "fmt"

func GritSScore(perseveranceEffort float64, consistencyInterest float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterest
}

func main() {
	fmt.Printf("Synthetic Short Grit Scale score: %.3f\n", GritSScore(0.74, 0.61))
}
