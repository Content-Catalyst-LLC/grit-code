package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func QuittingPressureIndex(
	cumulativeCost,
	healthRisk,
	goalMisalignment,
	opportunityCost,
	futureValue,
	learningPotential,
	purposeAlignment float64,
) float64 {
	return 0.24*cumulativeCost +
		0.26*healthRisk +
		0.24*goalMisalignment +
		0.20*opportunityCost -
		0.24*futureValue -
		0.20*learningPotential -
		0.24*purposeAlignment
}

func AlternativeGoalValueIndex(
	alternativeMeaning,
	alternativeFeasibility,
	alternativeSupport,
	transitionCost float64,
) float64 {
	return 0.30*alternativeMeaning +
		0.28*alternativeFeasibility +
		0.24*alternativeSupport -
		0.18*transitionCost
}

func main() {
	grit := GritScore(0.82, 0.64)
	quittingPressure := QuittingPressureIndex(0.22, 0.18, 0.10, 0.20, 0.76, 0.72, 0.82)
	alternativeValue := AlternativeGoalValueIndex(0.70, 0.62, 0.78, 0.28)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic quitting pressure index: %.3f\n", quittingPressure)
	fmt.Printf("Synthetic alternative goal value index: %.3f\n", alternativeValue)
}
