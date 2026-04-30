package main

import "fmt"

func adaptivePersistence(persistence, expectedValue, goalFit, burnoutRisk float64) float64 {
	return persistence*(expectedValue+goalFit) - burnoutRisk
}

func main() {
	score := adaptivePersistence(0.78, 0.70, 0.65, 0.25)
	fmt.Printf("Adaptive persistence score: %.3f\n", score)
}
