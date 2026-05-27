package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func NarrativeIdentityScore(narrativeCoherence, agency, meaningMaking, futureOrientation float64) float64 {
	return 0.28*narrativeCoherence +
		0.26*agency +
		0.24*meaningMaking +
		0.22*futureOrientation
}

func PersistenceReadinessIndex(
	grit,
	narrativeIdentity,
	socialSupport,
	institutionalTrust,
	burnout,
	narrativeStrain float64,
) float64 {
	return 0.20*grit +
		0.26*narrativeIdentity +
		0.18*socialSupport +
		0.16*institutionalTrust -
		0.16*burnout -
		0.12*narrativeStrain
}

func main() {
	grit := GritScore(0.82, 0.64)
	narrativeIdentity := NarrativeIdentityScore(0.76, 0.82, 0.70, 0.84)
	readiness := PersistenceReadinessIndex(grit, narrativeIdentity, 0.58, 0.72, -0.30, -0.28)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic narrative identity score: %.3f\n", narrativeIdentity)
	fmt.Printf("Synthetic persistence readiness index: %.3f\n", readiness)
}
