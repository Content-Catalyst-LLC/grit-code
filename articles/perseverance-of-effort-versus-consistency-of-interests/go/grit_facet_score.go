package main

import "fmt"

func GritTotalScore(perseveranceEffort float64, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func main() {
	fmt.Printf("Synthetic grit total score: %.3f\n", GritTotalScore(0.82, 0.71))
}
