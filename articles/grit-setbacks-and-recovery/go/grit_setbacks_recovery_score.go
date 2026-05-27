package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func RecoveryCapacityScore(
	emotionalRecovery,
	cognitiveRecovery,
	physicalRestoration,
	socialSupport,
	practicalResources float64,
) float64 {
	return 0.22*emotionalRecovery +
		0.22*cognitiveRecovery +
		0.18*physicalRestoration +
		0.20*socialSupport +
		0.18*practicalResources
}

func AdaptivePersistenceIndex(
	grit,
	setbackSeverity,
	recoveryCapacity,
	feedbackQuality,
	opportunityAccess,
	burnout float64,
) float64 {
	return 0.18*grit -
		0.22*setbackSeverity +
		0.28*recoveryCapacity +
		0.18*feedbackQuality +
		0.18*opportunityAccess -
		0.20*burnout
}

func main() {
	grit := GritScore(0.82, 0.64)
	recovery := RecoveryCapacityScore(0.74, 0.82, 0.66, 0.58, 0.62)
	persistence := AdaptivePersistenceIndex(grit, -0.28, recovery, 0.61, 0.70, -0.30)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic recovery capacity score: %.3f\n", recovery)
	fmt.Printf("Synthetic adaptive persistence index: %.3f\n", persistence)
}
