package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func MotivationScore(intrinsicInterest, identifiedValue, purposeOrientation, extrinsicPressure float64) float64 {
	return 0.30*intrinsicInterest +
		0.30*identifiedValue +
		0.30*purposeOrientation +
		0.10*extrinsicPressure
}

func HierarchyCoherenceScore(superordinateClarity, midlevelPlanning, dailyActionAlignment float64) float64 {
	return 0.35*superordinateClarity +
		0.30*midlevelPlanning +
		0.35*dailyActionAlignment
}

func main() {
	grit := GritScore(0.82, 0.64)
	motivation := MotivationScore(0.71, 0.78, 0.84, 0.25)
	hierarchy := HierarchyCoherenceScore(0.86, 0.74, 0.69)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic motivation score: %.3f\n", motivation)
	fmt.Printf("Synthetic goal-hierarchy coherence score: %.3f\n", hierarchy)
}
