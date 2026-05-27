package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func PersistenceReadinessIndex(
	grit,
	selfControl,
	belonging,
	socialSupport,
	financialStress,
	burnout float64,
) float64 {
	return 0.22*grit +
		0.18*selfControl +
		0.22*belonging +
		0.18*socialSupport -
		0.20*financialStress -
		0.18*burnout
}

func main() {
	grit := GritScore(0.82, 0.64)
	readiness := PersistenceReadinessIndex(grit, 0.72, 0.74, 0.58, -0.42, -0.30)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic academic persistence readiness index: %.3f\n", readiness)
}
