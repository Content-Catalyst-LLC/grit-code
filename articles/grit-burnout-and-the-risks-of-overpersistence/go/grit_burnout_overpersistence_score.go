package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func OverpersistenceIndex(
	grit,
	sunkCost,
	identityPressure,
	goalRigidity,
	feedbackResponsiveness,
	goalFit float64,
) float64 {
	return 0.22*grit +
		0.24*sunkCost +
		0.22*identityPressure +
		0.20*goalRigidity -
		0.22*feedbackResponsiveness -
		0.20*goalFit
}

func BurnoutRiskIndex(
	demandIntensity,
	overpersistence,
	goalRigidity,
	grit,
	recoveryCapacity,
	socialSupport,
	autonomy float64,
) float64 {
	return 0.24*demandIntensity +
		0.22*overpersistence +
		0.18*goalRigidity +
		0.16*grit -
		0.26*recoveryCapacity -
		0.20*socialSupport -
		0.18*autonomy
}

func main() {
	grit := GritScore(0.82, 0.64)
	overpersistence := OverpersistenceIndex(grit, 0.38, 0.34, 0.30, 0.74, 0.80)
	burnout := BurnoutRiskIndex(0.42, overpersistence, 0.30, grit, 0.70, 0.62, 0.68)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic overpersistence index: %.3f\n", overpersistence)
	fmt.Printf("Synthetic burnout risk index: %.3f\n", burnout)
}
