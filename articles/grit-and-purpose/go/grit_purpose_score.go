package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func PurposeScore(personalMeaning, longTermDirection, beyondSelfContribution float64) float64 {
	return 0.34*personalMeaning +
		0.33*longTermDirection +
		0.33*beyondSelfContribution
}

func PersistenceReadinessIndex(grit, purpose, socialSupport, autonomySupport, burnout float64) float64 {
	return 0.22*grit +
		0.28*purpose +
		0.18*socialSupport +
		0.18*autonomySupport -
		0.18*burnout
}

func main() {
	grit := GritScore(0.82, 0.64)
	purpose := PurposeScore(0.74, 0.82, 0.88)
	readiness := PersistenceReadinessIndex(grit, purpose, 0.58, 0.72, -0.30)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic purpose score: %.3f\n", purpose)
	fmt.Printf("Synthetic persistence readiness index: %.3f\n", readiness)
}
